import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/datasources/trade_datasource.dart';
import 'package:price_action_orders/data/models/order_cancel_response_model.dart';
import 'package:price_action_orders/data/models/order_response_full_model.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import '../../attachments/attachment_reader.dart';
import 'trade_datasource_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])
void main() {
  late TradeDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TradeDataSourceImpl(mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(String method, String jsonData) {
    switch (method) {
      case 'post':
        when(mockHttpClient.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(jsonData, 200));
        break;
      case 'delete':
        when(mockHttpClient.delete(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(jsonData, 200));
        break;
    }
  }

  void setUpMockHttpClientFailure404(String method) {
    switch (method) {
      case 'post':
        when(mockHttpClient.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{}', 404));
        break;
      case 'delete':
        when(mockHttpClient.delete(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response('{}', 404));
        break;
    }
  }

  group('postLimitOrder', () {
    final tJsonData = attachment('order_limit_response_full.json');
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final LimitOrderRequest tLimitOrder = LimitOrderRequest(
      ticker: tTicker,
      side: BinanceOrderSide.SELL,
      timeInForce: BinanceOrderTimeInForce.GTC,
      quantity: Decimal.parse('0.5'),
      price: Decimal.parse('338'),
    );
    final OrderResponseFull tOrderResponseFull = OrderResponseFullModel(
      ticker: tTicker,
      symbol: 'BNBUSDT',
      orderId: 4216025,
      orderListId: -1,
      clientOrderId: 'vrS5zRiFj7dgxOuK9Pr7M4',
      transactTime: 1624643274441,
      price: Decimal.parse('338.00000000'),
      origQty: Decimal.parse('0.50000000'),
      executedQty: Decimal.parse('0.00000000'),
      cummulativeQuoteQty: Decimal.parse('0.00000000'),
      status: BinanceOrderStatus.NEW,
      timeInForce: BinanceOrderTimeInForce.GTC,
      type: BinanceOrderType.LIMIT,
      side: BinanceOrderSide.SELL,
      fills: [],
    );

    test(
      'should perform a POST request on a URL with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('post', tJsonData);
        //act
        await dataSource.postLimitOrder(tLimitOrder);
        //assert
        verify(mockHttpClient.post(any, headers: anyNamed('headers')));
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      'should return a full order response when the response code is 200 (success)',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('post', tJsonData);
        //act
        final result = await dataSource.postLimitOrder(tLimitOrder);
        //assert
        expect(result, tOrderResponseFull);
      },
    );

    test(
      'should throw a server exception when the response code is not 200 (failure)',
      () async {
        //arrange
        setUpMockHttpClientFailure404('post');
        //assert
        expect(() => dataSource.postLimitOrder(tLimitOrder), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('postMarketOrder', () {
    final tJsonData = attachment('order_market_response_full.json');
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final MarketOrderRequest tMarketOrder = MarketOrderRequest(
      ticker: tTicker,
      side: BinanceOrderSide.BUY,
      quoteOrderQty: Decimal.parse('100'),
    );
    final OrderResponseFull tOrderResponseFull = OrderResponseFullModel(
      ticker: tTicker,
      symbol: 'BNBUSDT',
      orderId: 4226074,
      orderListId: -1,
      clientOrderId: 'Cv8hnooxL2VzBVO9fBRDWv',
      transactTime: 1624647959471,
      price: Decimal.parse('0.00000000'),
      origQty: Decimal.parse('0.35000000'),
      executedQty: Decimal.parse('0.35000000'),
      cummulativeQuoteQty: Decimal.parse('99.02550000'),
      status: BinanceOrderStatus.FILLED,
      timeInForce: BinanceOrderTimeInForce.GTC,
      type: BinanceOrderType.MARKET,
      side: BinanceOrderSide.BUY,
      fills: [
        OrderFill(
          price: Decimal.parse('282.93000000'),
          quantity: Decimal.parse('0.35000000'),
          commission: Decimal.parse('0.00000000'),
          commissionAsset: 'BNB',
          tradeId: 569246,
        ),
      ],
    );

    test(
      'should perform a POST request on a URL with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('post', tJsonData);
        //act
        await dataSource.postMarketOrder(tMarketOrder);
        //assert
        verify(mockHttpClient.post(any, headers: anyNamed('headers')));
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      'should return a full order response when the response code is 200 (success)',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('post', tJsonData);
        //act
        final result = await dataSource.postMarketOrder(tMarketOrder);
        //assert
        expect(result, tOrderResponseFull);
      },
    );

    test(
      'should throw a server exception when the response code is not 200 (failure)',
      () async {
        //arrange
        setUpMockHttpClientFailure404('post');
        //assert
        expect(() => dataSource.postMarketOrder(tMarketOrder), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('postCancelOrder', () {
    final tJsonData = attachment('cancel_order_response.json');
    final CancelOrderRequest tCancelOrderRequest = CancelOrderRequest(symbol: 'BNBUSDT', orderId: 4201377);
    final CancelOrderResponse tCancelOrderResponse = CancelOrderResponseModel(
      symbol: 'BNBUSDT',
      origClientOrderId: 'gwwiVwQrlmxPiv4PAh5TT5',
      orderId: 4201377,
      orderListId: -1,
      clientOrderId: '8aDxzSltUbLhfEeNGacTz5',
      price: Decimal.parse('300.00000000'),
      origQty: Decimal.parse('300.00000000'),
      executedQty: Decimal.parse('0.00000000'),
      cummulativeQuoteQty: Decimal.parse('0.00000000'),
      status: BinanceOrderStatus.CANCELED,
      timeInForce: BinanceOrderTimeInForce.GTC,
      type: BinanceOrderType.LIMIT,
      side: BinanceOrderSide.SELL,
    );

    test(
      'should perform a DELETE request on a URL with application/json header',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('delete', tJsonData);
        //act
        await dataSource.postCancelOrder(tCancelOrderRequest);
        //assert
        verify(mockHttpClient.delete(any, headers: anyNamed('headers')));
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      'should return a cancel order response when the response code is 200 (success)',
      () async {
        //arrange
        setUpMockHttpClientSuccess200('delete', tJsonData);
        //act
        final result = await dataSource.postCancelOrder(tCancelOrderRequest);
        //assert
        expect(result, tCancelOrderResponse);
      },
    );

    test(
      'should throw a server exception when the response code is not 200 (failure)',
      () async {
        //arrange
        setUpMockHttpClientFailure404('delete');
        //assert
        expect(() => dataSource.postCancelOrder(tCancelOrderRequest), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
