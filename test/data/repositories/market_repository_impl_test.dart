import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/datasources/market_datasource.dart';
import 'package:price_action_orders/data/models/exchange_info_model.dart';
import 'package:price_action_orders/data/models/exchange_symbol_info_model.dart';
import 'package:price_action_orders/data/repositories/market_repository_impl.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import 'market_repository_impl_test.mocks.dart';

final _bookTickers = [
  BookTicker(
    updatedId: 1624022520704,
    symbol: 'BNBUSDT',
    ticker: Ticker(baseAsset: 'BNB', quoteAsset: 'USDT'),
    bidPrice: Decimal.parse('353'),
    bidQty: Decimal.parse('1.5'),
    askPrice: Decimal.parse('354'),
    askQty: Decimal.parse('2'),
  ),
  BookTicker(
    updatedId: 1624022520704,
    symbol: 'BNBUSDT',
    ticker: Ticker(baseAsset: 'BNB', quoteAsset: 'USDT'),
    bidPrice: Decimal.parse('353.5'),
    bidQty: Decimal.parse('1.1'),
    askPrice: Decimal.parse('354.2'),
    askQty: Decimal.parse('1.5'),
  ),
];

final _exchangeSymbolInfoModel = ExchangeSymbolInfoModel(
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

@GenerateMocks([MarketDataSource])
void main() {
  late MarketRepositoryImpl repository;
  late MockMarketDataSource mockMarketDataSource;

  setUp(() {
    mockMarketDataSource = MockMarketDataSource();
    repository = MarketRepositoryImpl(mockMarketDataSource);
  });

  group('getBookTickerStream', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final Stream<BookTicker> tBookTickerStream = Stream<BookTicker>.fromIterable(_bookTickers);

    test(
      'should return BookTicker stream when the call to data source is successful',
      () async {
        //arrange
        when(mockMarketDataSource.getBookTickerStream(tTicker)).thenAnswer((_) async => tBookTickerStream);
        //act
        final result = await repository.getBookTickerStream(tTicker);
        //assert
        verify(mockMarketDataSource.getBookTickerStream(tTicker));
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Right(tBookTickerStream));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful',
      () async {
        //arrange
        when(mockMarketDataSource.getBookTickerStream(tTicker)).thenThrow(ServerException(message: "Could not obtain BookTicker stream."));
        //act
        final result = await repository.getBookTickerStream(tTicker);
        //assert
        verify(mockMarketDataSource.getBookTickerStream(tTicker));
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Left(ServerFailure(message: "Could not obtain BookTicker stream.")));
      },
    );
  });

  group('getTickerStatsStream', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final Stream<TickerStats> tTickerStatsStream = Stream<TickerStats>.empty();

    test(
      'should return TickerStats stream when the call to data source is successful',
      () async {
        //arrange
        when(mockMarketDataSource.getTickerStatsStream(tTicker)).thenAnswer((_) async => tTickerStatsStream);
        //act
        final result = await repository.getTickerStatsStream(tTicker);
        //assert
        verify(mockMarketDataSource.getTickerStatsStream(tTicker));
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Right(tTickerStatsStream));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful',
      () async {
        //arrange
        when(mockMarketDataSource.getTickerStatsStream(tTicker)).thenThrow(ServerException(message: "Could not obtain TickerStats stream."));
        //act
        final result = await repository.getTickerStatsStream(tTicker);
        //assert
        verify(mockMarketDataSource.getTickerStatsStream(tTicker));
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Left(ServerFailure(message: "Could not obtain TickerStats stream.")));
      },
    );
  });

  group('getExchangeInfo', () {
    final tExchangeInfoModel = ExchangeInfoModel(
      timezone: 'UTC',
      serverTime: 1628692692594,
      rateLimits: [
        {"rateLimitType": "REQUEST_WEIGHT", "interval": "MINUTE", "intervalNum": 1, "limit": 1200},
        {"rateLimitType": "ORDERS", "interval": "SECOND", "intervalNum": 10, "limit": 50},
        {"rateLimitType": "ORDERS", "interval": "DAY", "intervalNum": 1, "limit": 160000},
        {"rateLimitType": "RAW_REQUESTS", "interval": "MINUTE", "intervalNum": 5, "limit": 6100},
      ],
      exchangeFilters: [],
      symbols: [_exchangeSymbolInfoModel],
    );

    test(
      'should return ExchangeInfo when the call to data source is successful',
      () async {
        //arrange
        when(mockMarketDataSource.getExchangeInfo()).thenAnswer((_) async => tExchangeInfoModel);
        //act
        final result = await repository.getExchangeInfo();
        //assert
        verify(mockMarketDataSource.getExchangeInfo());
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Right(tExchangeInfoModel));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful',
      () async {
        //arrange
        when(mockMarketDataSource.getExchangeInfo()).thenThrow(BinanceException());
        //act
        final result = await repository.getExchangeInfo();
        //assert
        verify(mockMarketDataSource.getExchangeInfo());
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Left(ServerFailure(message: "Something went wrong.")));
      },
    );
  });
}
