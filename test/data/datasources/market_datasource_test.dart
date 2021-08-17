import 'dart:async';
import 'dart:io' show WebSocket;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/utils/datasource_utils.dart';
import 'package:price_action_orders/data/datasources/market_datasource.dart';
import 'package:price_action_orders/data/models/exchange_info_model.dart';
import 'package:price_action_orders/data/models/exchange_symbol_info_model.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import '../../attachments/attachment_reader.dart';
import 'market_datasource_test.mocks.dart';

class _FakeWebSocket extends Fake implements WebSocket {
  StreamSubscription<dynamic> _streamSubscription = Stream<dynamic>.empty().listen((event) {});

  @override
  int get readyState => WebSocket.open;
  @override
  Future<void> close([int? code, String? reason]) => _streamSubscription.cancel();
  @override
  StreamSubscription<dynamic> listen(void onData(dynamic event)?, {Function? onError, void onDone()?, bool? cancelOnError}) => _streamSubscription;
}

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

@GenerateMocks([DataSourceUtils], customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])
void main() {
  late MarketDataSourceImpl dataSource;
  late MockDataSourceUtils mockDataSourceUtils;
  late MockHttpClient mockHttpClient;

  final AppMode tmode = AppMode.TEST;
  final String tkey = 'HFKJGFbjhasfbka87b210dfgnskdgmhaskKJABhjabsf72anmbASDJFMNb4hg4L1';
  final String tsecret = 'Gjn8oJNHTkjnsgKHFKJQ3m1rkamnfbkgnKJBnwgdfhnmmsndfBJJyhgwajbnnafK';

  setUp(() {
    mockDataSourceUtils = MockDataSourceUtils();
    mockHttpClient = MockHttpClient();
    dataSource = MarketDataSourceImpl(dataSourceUtils: mockDataSourceUtils, httpClient: mockHttpClient);
    
    setGlobalModeVariables(tmode, tkey, tsecret);
  });

  group('getBookTickerStream', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final _FakeWebSocket tWebSocket = _FakeWebSocket();
    tWebSocket.close();

    test(
      'should establish a websocket connection and return a bookticker stream when the communication is successful',
      () async {
        //arrange
        when(mockDataSourceUtils.webSocketConnect(any)).thenAnswer((_) async => tWebSocket);
        //act
        final result = await dataSource.getBookTickerStream(tTicker);
        //assert
        verify(mockDataSourceUtils.webSocketConnect(any));
        verifyNoMoreInteractions(mockDataSourceUtils);
        expect(result, isA<Stream<BookTicker>>());
      },
    );

    test(
      'should throw a server exception when the communication is unsuccessful',
      () async {
        //arrange
        when(mockDataSourceUtils.webSocketConnect(any)).thenThrow(Error());
        //assert
        expect(() => dataSource.getBookTickerStream(tTicker), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('getTickerStatsStream', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final _FakeWebSocket tWebSocket = _FakeWebSocket();
    tWebSocket.close();

    test(
      'should establish a websocket connection and return a ticker stats stream when the communication is successful',
      () async {
        //arrange
        when(mockDataSourceUtils.webSocketConnect(any)).thenAnswer((_) async => tWebSocket);
        //act
        final result = await dataSource.getTickerStatsStream(tTicker);
        //assert
        verify(mockDataSourceUtils.webSocketConnect(any));
        verifyNoMoreInteractions(mockDataSourceUtils);
        expect(result, isA<Stream<TickerStats>>());
      },
    );

    test(
      'should throw a server exception when the communication is unsuccessful',
      () async {
        //arrange
        when(mockDataSourceUtils.webSocketConnect(any)).thenThrow(Error());
        //assert
        expect(() => dataSource.getTickerStatsStream(tTicker), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('getExchangeInfo', () {
    final tJsonData = attachment('exchange_info.json');
    final exchangeInfo = ExchangeInfoModel(
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
      'should perform a GET request on a URL with application/json header',
      () async {
        //arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tJsonData, 200));
        //act
        await dataSource.getExchangeInfo();
        //assert
        verify(mockHttpClient.get(any, headers: anyNamed('headers')));
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      'should return exchangeInfo when the response code is 200 (success)',
      () async {
        //arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(tJsonData, 200));
        //act
        final result = await dataSource.getExchangeInfo();
        //assert
        expect(result, exchangeInfo);
      },
    );

    test(
      'should throw a server exception when the response code is not 200 (failure)',
      () async {
        //arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{}', 404));
        //assert
        expect(() => dataSource.getExchangeInfo(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
