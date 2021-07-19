import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/usecases/post_trade_cancel_order.dart' as pco;
import 'package:price_action_orders/domain/usecases/post_trade_limit_order.dart' as plo;
import 'package:price_action_orders/domain/usecases/post_trade_market_order.dart' as pmo;
import 'package:price_action_orders/presentation/logic/trade_state_notifier.dart';
import 'trade_state_notifier_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<plo.PostLimitOrder>(as: #MockPostLimitOrder),
  MockSpec<pmo.PostMarketOrder>(as: #MockPostMarketOrder),
  MockSpec<pco.PostCancelOrder>(as: #MockPostCancelOrder),
])
void main() {
  late TradeNotifier notifier;
  late MockPostLimitOrder mockPostLimitOrder;
  late MockPostMarketOrder mockPostMarketOrder;
  late MockPostCancelOrder mockPostCancelOrder;

  setUp(() {
    mockPostLimitOrder = MockPostLimitOrder();
    mockPostMarketOrder = MockPostMarketOrder();
    mockPostCancelOrder = MockPostCancelOrder();
    notifier = TradeNotifier(postLimitOrder: mockPostLimitOrder, postMarketOrder: mockPostMarketOrder, postCancelOrder: mockPostCancelOrder);
  });

  group('postLimitOrder', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final tLimitOrder = LimitOrderRequest(
      ticker: tTicker,
      side: BinanceOrderSide.BUY,
      timeInForce: BinanceOrderTimeInForce.GTC,
      quantity: Decimal.parse('10.00000000'),
      price: Decimal.parse('100.00000000'),
    );
    final tOrderResponse = OrderResponseFull(
      ticker: tTicker,
      symbol: 'BNBUSDT',
      orderId: 123456,
      orderListId: -1,
      clientOrderId: '6gCrw2kRUAF9CvJDGP16IP',
      transactTime: 1507725176595,
      price: Decimal.parse('100.00000000'),
      origQty: Decimal.parse('10.00000000'),
      executedQty: Decimal.zero,
      cummulativeQuoteQty: Decimal.zero,
      status: BinanceOrderStatus.NEW,
      timeInForce: BinanceOrderTimeInForce.GTC,
      type: BinanceOrderType.LIMIT,
      side: BinanceOrderSide.BUY,
      fills: [],
    );

    test(
      'should state TradeInitial, TradeLoading, and TradeLoaded when the request to the server is successful',
      () async {
        //arrange
        final List<TradeState> tStates = [
          TradeInitial(),
          TradeLoading(tLimitOrder.timestamp),
          TradeLoaded(tOrderResponse),
        ];
        final List<TradeState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockPostLimitOrder.call(plo.Params(tLimitOrder))).thenAnswer((_) async => Right(tOrderResponse));
        //act
        await notifier.postLimitOrder(tLimitOrder);
        //assert
        verify(mockPostLimitOrder.call(plo.Params(tLimitOrder)));
        verifyNoMoreInteractions(mockPostLimitOrder);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state TradeInitial, TradeLoading, and TradeError when the request to the server is unsuccessful',
      () async {
        //arrange
        final List<TradeState> tStates = [
          TradeInitial(),
          TradeLoading(tLimitOrder.timestamp),
          TradeError(orderTimestamp: tLimitOrder.timestamp, message: 'Something went wrong.'),
        ];
        final List<TradeState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockPostLimitOrder.call(plo.Params(tLimitOrder))).thenAnswer((_) async => Left(ServerFailure()));
        //act
        await notifier.postLimitOrder(tLimitOrder);
        //assert
        verify(mockPostLimitOrder.call(plo.Params(tLimitOrder)));
        verifyNoMoreInteractions(mockPostLimitOrder);
        expect(actualStates, tStates);
      },
    );
  });

  group('postMarketOrder', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final tMarketOrder = MarketOrderRequest(
      ticker: tTicker,
      side: BinanceOrderSide.SELL,
      quantity: Decimal.parse('10.00000000'),
    );
    final tOrderResponse = OrderResponseFull(
      ticker: tTicker,
      symbol: 'BNBUSDT',
      orderId: 123457,
      orderListId: -1,
      clientOrderId: 'vgtrw2kRUAF9CyteGP14MR',
      transactTime: 1507725177809,
      price: Decimal.zero,
      origQty: Decimal.parse('10.00000000'),
      executedQty: Decimal.parse('10.00000000'),
      cummulativeQuoteQty: Decimal.zero,
      status: BinanceOrderStatus.FILLED,
      timeInForce: BinanceOrderTimeInForce.GTC,
      type: BinanceOrderType.MARKET,
      side: BinanceOrderSide.SELL,
      fills: [
        OrderFill(
          price: Decimal.parse('103.00000000'),
          quantity: Decimal.parse('5.00000000'),
          commission: Decimal.zero,
          commissionAsset: 'USDT',
          tradeId: 987654321,
        ),
        OrderFill(
          price: Decimal.parse('105.00000000'),
          quantity: Decimal.parse('5.00000000'),
          commission: Decimal.zero,
          commissionAsset: 'USDT',
          tradeId: 987654322,
        ),
      ],
    );

    test(
      'should state TradeInitial, TradeLoading, and TradeLoaded when the request to the server is successful',
      () async {
        //arrange
        final List<TradeState> tStates = [
          TradeInitial(),
          TradeLoading(tMarketOrder.timestamp),
          TradeLoaded(tOrderResponse),
        ];
        final List<TradeState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockPostMarketOrder.call(pmo.Params(tMarketOrder))).thenAnswer((_) async => Right(tOrderResponse));
        //act
        await notifier.postMarketOrder(tMarketOrder);
        //assert
        verify(mockPostMarketOrder.call(pmo.Params(tMarketOrder)));
        verifyNoMoreInteractions(mockPostMarketOrder);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state TradeInitial, TradeLoading, and TradeError when the request to the server is unsuccessful',
      () async {
        //arrange
        final List<TradeState> tStates = [
          TradeInitial(),
          TradeLoading(tMarketOrder.timestamp),
          TradeError(orderTimestamp: tMarketOrder.timestamp, message: 'Something went wrong.'),
        ];
        final List<TradeState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockPostMarketOrder.call(pmo.Params(tMarketOrder))).thenAnswer((_) async => Left(ServerFailure()));
        //act
        await notifier.postMarketOrder(tMarketOrder);
        //assert
        verify(mockPostMarketOrder.call(pmo.Params(tMarketOrder)));
        verifyNoMoreInteractions(mockPostMarketOrder);
        expect(actualStates, tStates);
      },
    );
  });

  group('postCancelOrder', () {
    final tCancelOrder = CancelOrderRequest(symbol: 'BNBUSDT', orderId: 123456789);
    final tCancelOrderResponse = CancelOrderResponse(
      symbol: 'BNBUSDT',
      origClientOrderId: 'uTmrw2gTUAF9CyteGP09re',
      orderId: 123456789,
      orderListId: -1,
      clientOrderId: 'oOCrw2gTUBQ8CyteGP10jy',
      price: Decimal.parse('300.00000000'),
      origQty: Decimal.parse('10.00000000'),
      executedQty: Decimal.zero,
      cummulativeQuoteQty: Decimal.zero,
      status: BinanceOrderStatus.CANCELED,
      timeInForce: BinanceOrderTimeInForce.GTC,
      type: BinanceOrderType.LIMIT,
      side: BinanceOrderSide.SELL,
    );

    test(
      'should state TradeInitial, and TradeLoading when the request to the server is successful',
      () async {
        //arrange
        final List<TradeState> tStates = [
          TradeInitial(),
          TradeLoading(tCancelOrder.timestamp),
        ];
        final List<TradeState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockPostCancelOrder.call(pco.Params(tCancelOrder))).thenAnswer((_) async => Right(tCancelOrderResponse));
        //act
        await notifier.postCancelOrder(tCancelOrder);
        //assert
        verify(mockPostCancelOrder.call(pco.Params(tCancelOrder)));
        verifyNoMoreInteractions(mockPostCancelOrder);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state TradeInitial, TradeLoading, and TradeError when the request to the server is unsuccessful',
      () async {
        //arrange
        final List<TradeState> tStates = [
          TradeInitial(),
          TradeLoading(tCancelOrder.timestamp),
          TradeError(orderTimestamp: tCancelOrder.timestamp, message: 'Something went wrong.')
        ];
        final List<TradeState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockPostCancelOrder.call(pco.Params(tCancelOrder))).thenAnswer((_) async => Left(ServerFailure()));
        //act
        await notifier.postCancelOrder(tCancelOrder);
        //assert
        verify(mockPostCancelOrder.call(pco.Params(tCancelOrder)));
        verifyNoMoreInteractions(mockPostCancelOrder);
        expect(actualStates, tStates);
      },
    );
  });
}
