import 'dart:async';
import 'dart:io';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/constants.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/utils/datasource_utils.dart';
import 'package:price_action_orders/data/datasources/user_datasource.dart';
import 'package:price_action_orders/data/models/order_model.dart';
import 'package:price_action_orders/data/models/ticker_model.dart';
import 'package:price_action_orders/data/models/userdata_model.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/order.dart' as entity;
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../attachments/attachment_reader.dart';
import 'user_datasource_test.mocks.dart';

class _FakeWebSocket extends Fake implements WebSocket {
  StreamSubscription<dynamic> _streamSubscription = Stream<dynamic>.empty().listen((event) {});

  @override
  int get readyState => WebSocket.open;
  @override
  Future close([int? code, String? reason]) => _streamSubscription.cancel();
  @override
  StreamSubscription<dynamic> listen(void onData(dynamic event)?, {Function? onError, void onDone()?, bool? cancelOnError}) => _streamSubscription;
}

@GenerateMocks([SharedPreferences, DataSourceUtils], customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late UserDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  late MockDataSourceUtils mockDataSourceUtils;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockHttpClient = MockHttpClient();
    mockDataSourceUtils = MockDataSourceUtils();
    dataSource = UserDataSourceImpl(sharedPreferences: mockSharedPreferences, httpClient: mockHttpClient, dataSourceUtils: mockDataSourceUtils);
  });

  void setUpMockHttpClientSuccess200(String method, String jsonData) {
    switch (method) {
      case 'get':
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(jsonData, 200));
        break;
      case 'post':
        when(mockHttpClient.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(jsonData, 200));
        break;
      case 'put':
        when(mockHttpClient.put(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(jsonData, 200));
        break;
      case 'delete':
        when(mockHttpClient.delete(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(jsonData, 200));
        break;
    }
  }

  void setUpMockHttpClientFailure404(String method) {
    switch (method) {
      case 'get':
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{}', 404));
        break;
      case 'post':
        when(mockHttpClient.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{}', 404));
        break;
      case 'put':
        when(mockHttpClient.put(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{}', 404));
        break;
      case 'delete':
        when(mockHttpClient.delete(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{}', 404));
        break;
    }
  }

  group('getAccountInfo', () {
    final tJsonData = attachment('userdata.json');
    final UserData tUserData = UserDataModel(
      updateTime: 123456789,
      makerCommission: 15,
      takerCommission: 15,
      buyerCommission: 0,
      sellerCommission: 0,
      canTrade: true,
      canWithdraw: true,
      canDeposit: true,
      accountType: 'SPOT',
      balances: [
        Balance(asset: 'BTC', free: Decimal.parse('4723846.89208129'), locked: Decimal.parse('0.00000000')),
        Balance(asset: 'LTC', free: Decimal.parse('4763368.68006011'), locked: Decimal.parse('0.00000000')),
      ],
      permissions: ['SPOT'],
    );

    test(
      'should perform a GET request on a URL with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('get', tJsonData);
        //act
        await dataSource.getAccountInfo();
        //assert
        verify(mockHttpClient.get(any, headers: anyNamed('headers')));
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      'should return user data when the response code is 200 (success)',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('get', tJsonData);
        //act
        final result = await dataSource.getAccountInfo();
        //assert
        expect(result, tUserData);
      },
    );

    test(
      'should throw a server exception when the response code is not 200 (failure)',
      () async {
        //arrange
        setUpMockHttpClientFailure404('get');
        //assert
        expect(() => dataSource.getAccountInfo(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('getOpenOrders', () {
    final tJsonData = attachment('open_orders.json');
    final List<entity.Order> tOpenOrders = [
      OrderModel(
        symbol: 'BNBUSDT',
        orderId: 3109505,
        orderListId: -1,
        clientOrderId: 'jFmEGC3hhNRJ3kX0D0NYWG',
        price: Decimal.parse('1000.00000000'),
        origQty: Decimal.parse('1000.00000000'),
        executedQty: Decimal.parse('28.44000000'),
        cummulativeQuoteQty: Decimal.parse('28440.00000000'),
        status: BinanceOrderStatus.PARTIALLY_FILLED,
        timeInForce: BinanceOrderTimeInForce.GTC,
        type: BinanceOrderType.LIMIT,
        side: BinanceOrderSide.SELL,
        stopPrice: Decimal.parse('0.00000000'),
        icebergQty: Decimal.parse('0.00000000'),
        time: 1624138983618,
        updateTime: 1624189683172,
        isWorking: true,
        origQuoteOrderQty: Decimal.parse('0.00000000'),
      ),
      OrderModel(
        symbol: 'BNBUSDT',
        orderId: 4201286,
        orderListId: -1,
        clientOrderId: 'TaXHW80D8o3pAHpvgMZ92T',
        price: Decimal.parse('200.00000000'),
        origQty: Decimal.parse('500.00000000'),
        executedQty: Decimal.parse('0.00000000'),
        cummulativeQuoteQty: Decimal.parse('0.00000000'),
        status: BinanceOrderStatus.NEW,
        timeInForce: BinanceOrderTimeInForce.GTC,
        type: BinanceOrderType.LIMIT,
        side: BinanceOrderSide.BUY,
        stopPrice: Decimal.parse('0.00000000'),
        icebergQty: Decimal.parse('0.00000000'),
        time: 1624636451631,
        updateTime: 1624636451631,
        isWorking: true,
        origQuoteOrderQty: Decimal.parse('0.00000000'),
      ),
    ];

    test(
      'should perform a GET request on a URL with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('get', tJsonData);
        //act
        await dataSource.getOpenOrders();
        //assert
        verify(mockHttpClient.get(any, headers: anyNamed('headers')));
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      'should return open orders when the response code is 200 (success)',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('get', tJsonData);
        //act
        final result = await dataSource.getOpenOrders();
        //assert
        expect(result, tOpenOrders);
      },
    );

    test(
      'should throw a server exception when the response code is not 200 (failure)',
      () async {
        //arrange
        setUpMockHttpClientFailure404('get');
        //assert
        expect(() => dataSource.getOpenOrders(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('getUserDataStream', () {
    final tJsonData = attachment('listen_key.json');
    final Timer timerResponse = Timer.periodic(Duration(minutes: 1), (timer) {});
    final _FakeWebSocket tWebSocket = _FakeWebSocket();
    tWebSocket.close();

    test(
      'should establish a websocket connection and return a dynamic stream when the communication is successful',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('post', tJsonData);
        when(mockDataSourceUtils.periodicValidityExpander(any, any)).thenReturn(timerResponse);
        when(mockDataSourceUtils.webSocketConnect(any)).thenAnswer((_) async => tWebSocket);
        //act
        final result = await dataSource.getUserDataStream();
        //assert
        verify(mockHttpClient.post(any, headers: anyNamed('headers')));
        verify(mockDataSourceUtils.periodicValidityExpander(any, any));
        verify(mockDataSourceUtils.webSocketConnect(any));
        verifyNoMoreInteractions(mockDataSourceUtils);
        expect(result, isA<Stream<dynamic>>());
      },
    );

    test(
      'should throw a server exception when cannot get a listen key',
      () async {
        //arrange
        setUpMockHttpClientFailure404('post');
        //assert
        expect(() => dataSource.getUserDataStream(), throwsA(isInstanceOf<ServerException>()));
      },
    );

    test(
      'should throw a server exception when cannot establish the websocket',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('post', tJsonData);
        when(mockDataSourceUtils.periodicValidityExpander(any, any)).thenReturn(timerResponse);
        when(mockDataSourceUtils.webSocketConnect(any)).thenThrow(Error());
        // act
        final call = dataSource.getUserDataStream;
        //assert
        expect(call(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('cacheLastTicker', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');

    test(
      'should call shared preferences to save the ticker',
      () async {
        //arrange
        when(mockSharedPreferences.setString(LAST_TICKER, any)).thenAnswer((_) async => true);
        //act
        await dataSource.cacheLastTicker(tTicker);
        //assert
        verify((mockSharedPreferences.setString(LAST_TICKER, any)));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });

  group('getLastTicker', () {
    final Ticker tTicker = TickerModel(baseAsset: 'BNB', quoteAsset: 'USDT');

    test(
      'should retrieve a previously cached ticker',
      () async {
        //arrange
        final String jsonString = attachment('ticker.json');
        when(mockSharedPreferences.getString(LAST_TICKER)).thenReturn(jsonString);
        //act
        final result = await dataSource.getLastTicker();
        //assert
        verify(mockSharedPreferences.getString(LAST_TICKER));
        verifyNoMoreInteractions(mockSharedPreferences);
        expect(result, tTicker);
      },
    );

    test(
      'should throw a cache exception when there is no ticker saved',
      () async {
        //arrange
        when(mockSharedPreferences.getString(LAST_TICKER)).thenReturn(null);
        //act
        final call = dataSource.getLastTicker;
        //assert
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
      },
    );
  });
}
