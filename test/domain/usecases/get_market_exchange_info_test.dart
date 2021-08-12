import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/data/models/exchange_info_model.dart';
import 'package:price_action_orders/data/models/exchange_symbol_info_model.dart';
import 'package:price_action_orders/domain/entities/exchange_info.dart';
import 'package:price_action_orders/domain/repositories/market_respository.dart';
import 'package:price_action_orders/domain/usecases/get_market_exchange_info.dart';
import 'get_market_exchange_info_test.mocks.dart';

final _exchangeSymbolInfo = ExchangeSymbolInfoModel(
  symbol: 'ETHBTC',
  status: 'TRADING',
  baseAsset: 'ETH',
  baseAssetPrecision: 8,
  quoteAsset: 'BTC',
  quotePrecision: 8,
  quoteAssetPrecision: 8,
  baseCommissionPrecision: 8,
  quoteCommissionPrecision: 8,
  orderTypes: [
    BinanceOrderType.LIMIT,
    BinanceOrderType.LIMIT_MAKER,
    BinanceOrderType.MARKET,
    BinanceOrderType.STOP_LOSS_LIMIT,
    BinanceOrderType.TAKE_PROFIT_LIMIT,
  ],
  icebergAllowed: true,
  ocoAllowed: true,
  quoteOrderQtyMarketAllowed: true,
  isSpotTradingAllowed: true,
  isMarginTradingAllowed: true,
  filters: [
    {"filterType": "PRICE_FILTER", "minPrice": "0.00000100", "maxPrice": "922327.00000000", "tickSize": "0.00000100"},
    {"filterType": "PERCENT_PRICE", "multiplierUp": "5", "multiplierDown": "0.2", "avgPriceMins": 5},
    {"filterType": "LOT_SIZE", "minQty": "0.00100000", "maxQty": "100000.00000000", "stepSize": "0.00100000"},
    {"filterType": "MIN_NOTIONAL", "minNotional": "0.00010000", "applyToMarket": true, "avgPriceMins": 5},
    {"filterType": "ICEBERG_PARTS", "limit": 10},
    {"filterType": "MARKET_LOT_SIZE", "minQty": "0.00000000", "maxQty": "1041.49940653", "stepSize": "0.00000000"},
    {"filterType": "MAX_NUM_ORDERS", "maxNumOrders": 200},
    {"filterType": "MAX_NUM_ALGO_ORDERS", "maxNumAlgoOrders": 5},
  ],
  permissions: ['SPOT', 'MARGIN'],
);

@GenerateMocks([MarketRepository])
void main() {
  late GetExchangeInfo usecase;
  late MockMarketRepository mockMarketRepository;

  setUp(() {
    mockMarketRepository = MockMarketRepository();
    usecase = GetExchangeInfo(mockMarketRepository);
  });

  final tExchangeInfo = ExchangeInfoModel(
    timezone: 'UTC',
    serverTime: 1628692692594,
    rateLimits: [
      {"rateLimitType": "REQUEST_WEIGHT", "interval": "MINUTE", "intervalNum": 1, "limit": 1200},
      {"rateLimitType": "ORDERS", "interval": "SECOND", "intervalNum": 10, "limit": 50},
      {"rateLimitType": "ORDERS", "interval": "DAY", "intervalNum": 1, "limit": 160000},
      {"rateLimitType": "RAW_REQUESTS", "interval": "MINUTE", "intervalNum": 5, "limit": 6100},
    ],
    exchangeFilters: [],
    symbols: [_exchangeSymbolInfo],
  );

  test(
    'should return exchange info when the call to the repository is successful',
    () async {
      //arrange
      when(mockMarketRepository.getExchangeInfo()).thenAnswer((_) async => Right(tExchangeInfo));
      //act
      final Either<Failure, ExchangeInfo> result = await usecase(NoParams());
      //assert
      verify(mockMarketRepository.getExchangeInfo());
      verifyNoMoreInteractions(mockMarketRepository);
      expect(result, Right(tExchangeInfo));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockMarketRepository.getExchangeInfo()).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final Either<Failure, ExchangeInfo> result = await usecase(NoParams());
      //assert
      verify(mockMarketRepository.getExchangeInfo());
      verifyNoMoreInteractions(mockMarketRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
