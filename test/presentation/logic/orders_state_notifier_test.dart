import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order.dart' as entity;
import 'package:price_action_orders/domain/entities/trade.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_orderupdate.dart';
import 'package:price_action_orders/domain/usecases/get_user_openorders.dart';
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/userdata_stream.dart';

class MockGetOpenOrders extends Mock implements GetOpenOrders {}

class MockUserDataStream extends Mock implements UserDataStream {}

void main() {
  OrdersNotifier notifier;
  MockGetOpenOrders mockGetOpenOrders;
  MockUserDataStream mockUserDataStream;

  setUp(() {
    mockGetOpenOrders = MockGetOpenOrders();
    mockUserDataStream = MockUserDataStream();
    notifier = OrdersNotifier(getOpenOrders: mockGetOpenOrders, userDataStream: mockUserDataStream, start: false);
  });

  group('getOpenOrders', () {
    final List<entity.Order> tOpenOrders1 = [
      entity.Order(
        symbol: 'BNBUSDT',
        orderId: 3109505,
        orderListId: -1,
        clientOrderId: 'jFmEGC3hhNRJ3kX0D0NYWG',
        price: Decimal.parse('1000.00000000'),
        origQty: Decimal.parse('1000.00000000'),
        executedQty: Decimal.parse('0.00000000'),
        cummulativeQuoteQty: Decimal.parse('0.00000000'),
        status: BinanceOrderStatus.NEW,
        timeInForce: BinanceOrderTimeInForce.GTC,
        type: BinanceOrderType.LIMIT,
        side: BinanceOrderSide.SELL,
        stopPrice: Decimal.parse('0.00000000'),
        icebergQty: Decimal.parse('0.00000000'),
        time: 1624138983618,
        updateTime: 1624138983618,
        isWorking: true,
        origQuoteOrderQty: Decimal.parse('0.00000000'),
      ),
      entity.Order(
        symbol: 'BNBUSDT',
        orderId: 3092189,
        orderListId: -1,
        clientOrderId: 'KhbCMI9VtpdRlOK5PVJ5JH',
        price: Decimal.parse('100.00000000'),
        origQty: Decimal.parse('100.00000000'),
        executedQty: Decimal.parse('0.00000000'),
        cummulativeQuoteQty: Decimal.parse('0.00000000'),
        status: BinanceOrderStatus.NEW,
        timeInForce: BinanceOrderTimeInForce.GTC,
        type: BinanceOrderType.LIMIT,
        side: BinanceOrderSide.BUY,
        stopPrice: Decimal.parse('0.00000000'),
        icebergQty: Decimal.parse('0.00000000'),
        time: 1624130594326,
        updateTime: 1624137245101,
        isWorking: true,
        origQuoteOrderQty: Decimal.parse('0.00000000'),
      ),
    ];
    final List<entity.Order> tOpenOrders2 = [
      entity.Order(
        symbol: 'BNBUSDT',
        orderId: 3109505,
        orderListId: -1,
        clientOrderId: 'jFmEGC3hhNRJ3kX0D0NYWG',
        price: Decimal.parse('1000.00000000'),
        origQty: Decimal.parse('1000.00000000'),
        executedQty: Decimal.parse('0.00000000'),
        cummulativeQuoteQty: Decimal.parse('0.00000000'),
        status: BinanceOrderStatus.NEW,
        timeInForce: BinanceOrderTimeInForce.GTC,
        type: BinanceOrderType.LIMIT,
        side: BinanceOrderSide.SELL,
        stopPrice: Decimal.parse('0.00000000'),
        icebergQty: Decimal.parse('0.00000000'),
        time: 1624138983618,
        updateTime: 1624138983618,
        isWorking: true,
        origQuoteOrderQty: Decimal.parse('0.00000000'),
      ),
    ];
    final List<entity.Order> tOrderHistory2 = [
      entity.Order(
        symbol: 'BNBUSDT',
        orderId: 3092189,
        orderListId: -1,
        clientOrderId: 'KhbCMI9VtpdRlOK5PVJ5JH',
        price: Decimal.parse('100.00000000'),
        origQty: Decimal.parse('100.00000000'),
        executedQty: Decimal.parse('100.00000000'),
        cummulativeQuoteQty: Decimal.parse('10000.00000000'),
        status: BinanceOrderStatus.FILLED,
        timeInForce: BinanceOrderTimeInForce.GTC,
        type: BinanceOrderType.LIMIT,
        side: BinanceOrderSide.BUY,
        stopPrice: Decimal.parse('0.00000000'),
        icebergQty: Decimal.parse('0.00000000'),
        time: 1624130594326,
        updateTime: 1625684921948,
        isWorking: true,
        origQuoteOrderQty: Decimal.parse('0.00000000'),
      ),
    ];
    final List<Trade> tTradeHistory2 = [
      Trade(
        symbol: 'BNBUSDT',
        orderId: 3092189,
        price: Decimal.parse('100.00000000'),
        executedQty: Decimal.parse('100.00000000'),
        quoteQty: Decimal.parse('10000.00000000'),
        side: BinanceOrderSide.BUY,
        time: 1625684921948,
        tradeId: 123456,
        commisionAmount: Decimal.zero,
        commisionAsset: 'BNB',
      ),
    ];
    final tOrderReport = UserDataPayloadOrderUpdate(
      eventType: BinanceUserDataPayloadEventType.executionReport,
      eventTime: 1625684921948,
      symbol: 'BNBUSDT',
      clientOrderId: 'HtNCMI0VtpdRlPK5PVJ5JH',
      side: BinanceOrderSide.BUY,
      orderType: BinanceOrderType.LIMIT,
      timeInForce: BinanceOrderTimeInForce.GTC,
      orderQuantity: Decimal.parse('100.00000000'),
      orderPrice: Decimal.parse('100.00000000'),
      stopPrice: Decimal.parse('0.00000000'),
      icebergQuantity: Decimal.parse('0.00000000'),
      orderListId: -1,
      originalClientOrderId: 'KhbCMI9VtpdRlOK5PVJ5JH',
      currentExecutionType: BinanceOrderExecutionType.TRADE,
      currentOrderStatus: BinanceOrderStatus.FILLED,
      orderRejectReason: null,
      orderId: 3092189,
      lastExecutedQuantity: Decimal.parse('100.00000000'),
      cumulativeFilledQuantity: Decimal.parse('100.00000000'),
      lastExecutedPrice: Decimal.parse('100.00000000'),
      commisionAmount: Decimal.zero,
      commisionAsset: 'BNB',
      transactionTime: 1625684921948,
      tradeId: 123456,
      orderIsOnTheBook: false,
      tradeIsTheMakerSide: true,
      orderCreationTime: 1624130594326,
      cumulativeQuoteAssetTransactedQuantity: Decimal.parse('100.00000000'),
      lastQuoteAssetTransactedQuantity: Decimal.parse('100.00000000'),
      quoteOrderQuantity: Decimal.parse('100.00000000'),
    );

    test(
      'should state OrdersInitial, OrdersLoading, and OrdersLoaded when the communication to the server is successful',
      () async {
        //arrange
        final List<OrdersState> tStates = [
          OrdersInitial(),
          OrdersLoading(),
          OrdersLoaded(openOrders: tOpenOrders1),
        ];
        final List<OrdersState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetOpenOrders.call(NoParams())).thenAnswer((_) async => Right(tOpenOrders1));
        when(mockUserDataStream.stream()).thenAnswer((_) => Stream<dynamic>.empty());
        //act
        await notifier.getOpenOrders();
        //assert
        verify(mockGetOpenOrders.call(NoParams()));
        verify(mockUserDataStream.stream());
        verifyNoMoreInteractions(mockGetOpenOrders);
        verifyNoMoreInteractions(mockUserDataStream);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state OrdersInitial, OrdersLoading, and OrdersError when the communication to the server is unsuccessful',
      () async {
        //arrange
        final List<OrdersState> tStates = [
          OrdersInitial(),
          OrdersLoading(),
          OrdersError('Something went wrong.'),
        ];
        final List<OrdersState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetOpenOrders.call(NoParams())).thenAnswer((_) async => Left(ServerFailure()));
        //act
        await notifier.getOpenOrders();
        //assert
        verify(mockGetOpenOrders.call(NoParams()));
        verifyNoMoreInteractions(mockGetOpenOrders);
        verifyZeroInteractions(mockUserDataStream);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state a new OrdersLoaded with data coming from the user data stream',
      () async {
        //arrange
        final List<OrdersState> tStates = [
          OrdersInitial(),
          OrdersLoading(),
          OrdersLoaded(openOrders: tOpenOrders1),
          OrdersLoaded(openOrders: tOpenOrders2, orderHistory: tOrderHistory2, tradeHistory: tTradeHistory2),
        ];
        final List<OrdersState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetOpenOrders.call(NoParams())).thenAnswer((_) async => Right(tOpenOrders1));
        when(mockUserDataStream.stream()).thenAnswer((_) => Stream<dynamic>.value(tOrderReport));
        //act
        await notifier.getOpenOrders();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetOpenOrders.call(NoParams()));
        verify(mockUserDataStream.stream());
        verifyNoMoreInteractions(mockGetOpenOrders);
        verifyNoMoreInteractions(mockUserDataStream);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state an OrdersError with an error coming from the user data stream',
      () async {
        //arrange
        final List<OrdersState> tStates = [
          OrdersInitial(),
          OrdersLoading(),
          OrdersLoaded(openOrders: tOpenOrders1),
          OrdersError('Something went wrong.'),
        ];
        final List<OrdersState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetOpenOrders.call(NoParams())).thenAnswer((_) async => Right(tOpenOrders1));
        when(mockUserDataStream.stream()).thenAnswer((_) => Stream<dynamic>.error(Error()));
        //act
        await notifier.getOpenOrders();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetOpenOrders.call(NoParams()));
        verify(mockUserDataStream.stream());
        verifyNoMoreInteractions(mockGetOpenOrders);
        verifyNoMoreInteractions(mockUserDataStream);
        expect(actualStates, tStates);
      },
    );
  });
}
