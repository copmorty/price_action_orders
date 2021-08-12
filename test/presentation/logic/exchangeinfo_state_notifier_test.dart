import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/data/models/exchange_info_model.dart';
import 'package:price_action_orders/data/models/exchange_symbol_info_model.dart';
import 'package:price_action_orders/domain/usecases/get_market_exchange_info.dart';
import 'package:price_action_orders/presentation/logic/exchangeinfo_state_notifier.dart';

import 'exchangeinfo_state_notifier_test.mocks.dart';

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

@GenerateMocks([GetExchangeInfo])
void main() {
  late ExchangeInfoNotifier notifier;
  late MockGetExchangeInfo mockGetExchangeInfo;

  setUp(() {
    mockGetExchangeInfo = MockGetExchangeInfo();
  });

  group('getExchangeInfo', () {
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
      'should return exchangeInfo from current ExchangeInfoLoaded state',
      () async {
        //arrange
        notifier = ExchangeInfoNotifier(getExchangeInfo: mockGetExchangeInfo, state: ExchangeInfoLoaded(tExchangeInfo));
        //act
        final result = await notifier.getExchangeInfo();
        //assert
        verifyZeroInteractions(mockGetExchangeInfo);
        expect(result, Right(tExchangeInfo));
      },
    );

    test(
      'should return exchangeInfo when the call to the repository is successful',
      () async {
        //arrange
        notifier = ExchangeInfoNotifier(getExchangeInfo: mockGetExchangeInfo);
        when(mockGetExchangeInfo.call(NoParams())).thenAnswer((_) async => Right(tExchangeInfo));
        //act
        final result = await notifier.getExchangeInfo();
        //assert
        verify(mockGetExchangeInfo.call(NoParams()));
        verifyNoMoreInteractions(mockGetExchangeInfo);
        expect(result, Right(tExchangeInfo));
      },
    );

    test(
      'should return a failure when the call to the repository is unsuccessful',
      () async {
        //arrange
        notifier = ExchangeInfoNotifier(getExchangeInfo: mockGetExchangeInfo);
        when(mockGetExchangeInfo.call(NoParams())).thenAnswer((_) async => Left(ServerFailure()));
        //act
        final result = await notifier.getExchangeInfo();
        //assert
        verify(mockGetExchangeInfo.call(NoParams()));
        verifyNoMoreInteractions(mockGetExchangeInfo);
        expect(result, Left(ServerFailure()));
      },
    );

    test(
      'should state ExchangeInfoInitial, ExchangeInfoLoading, ExchangeInfoLoaded when the repository call is successful',
      () async {
        //arrange
        notifier = ExchangeInfoNotifier(getExchangeInfo: mockGetExchangeInfo);
        final List<ExchangeInfoState> tStates = [
          ExchangeInfoInitial(),
          ExchangeInfoLoading(),
          ExchangeInfoLoaded(tExchangeInfo),
        ];
        final List<ExchangeInfoState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetExchangeInfo.call(NoParams())).thenAnswer((_) async => Right(tExchangeInfo));
        //act
        await notifier.getExchangeInfo();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetExchangeInfo.call(NoParams()));
        verifyNoMoreInteractions(mockGetExchangeInfo);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state ExchangeInfoInitial, ExchangeInfoLoading, ExchangeInfoError when the repository call is unsuccessful',
      () async {
        //arrange
        notifier = ExchangeInfoNotifier(getExchangeInfo: mockGetExchangeInfo);
        final List<ExchangeInfoState> tStates = [
          ExchangeInfoInitial(),
          ExchangeInfoLoading(),
          ExchangeInfoError('Something went wrong.'),
        ];
        final List<ExchangeInfoState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetExchangeInfo.call(NoParams())).thenAnswer((_) async => Left(ServerFailure()));
        //act
        await notifier.getExchangeInfo();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetExchangeInfo.call(NoParams()));
        verifyNoMoreInteractions(mockGetExchangeInfo);
        expect(actualStates, tStates);
      },
    );
  });
}
