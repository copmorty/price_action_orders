import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/datasources/trade_datasource.dart';
import 'package:price_action_orders/data/repositories/trade_repository_impl.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'trade_repository_impl_test.mocks.dart';

@GenerateMocks([TradeDataSource])
void main() {
  late TradeRepositoryImpl repository;
  late MockTradeDataSource mockTradeDataSource;

  setUp(() {
    mockTradeDataSource = MockTradeDataSource();
    repository = TradeRepositoryImpl(mockTradeDataSource);
  });

  group('postOrder', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final LimitOrderRequest tLimitOrder = LimitOrderRequest(
      ticker: tTicker,
      side: BinanceOrderSide.SELL,
      timeInForce: BinanceOrderTimeInForce.GTC,
      quantity: Decimal.parse('0.5'),
      price: Decimal.parse('338'),
    );
    final tOrderResponseFull = OrderResponseFull(
      ticker: tTicker,
      symbol: 'BNBUSDT',
      orderId: 3064643,
      orderListId: -1,
      clientOrderId: 'CfH1n7Zof0XrvDf0vMTc0c',
      transactTime: 1624117403814,
      price: Decimal.parse('338.00000000'),
      origQty: Decimal.parse('0.50000000'),
      executedQty: Decimal.parse('0.50000000'),
      cummulativeQuoteQty: Decimal.parse('169.76000000'),
      status: BinanceOrderStatus.FILLED,
      timeInForce: BinanceOrderTimeInForce.GTC,
      type: BinanceOrderType.LIMIT,
      side: BinanceOrderSide.SELL,
      fills: [
        OrderFill(
          price: Decimal.parse('339.52000000'),
          quantity: Decimal.parse('0.50000000'),
          commission: Decimal.parse('0.00000000'),
          commissionAsset: 'USDT',
          tradeId: 391921,
        ),
      ],
    );

    test(
      'should return a full order response when the call to data source is successful',
      () async {
        //arrange
        when(mockTradeDataSource.postOrder(tLimitOrder)).thenAnswer((_) async => tOrderResponseFull);
        //act
        final result = await repository.postOrder(tLimitOrder);
        //assert
        verify(mockTradeDataSource.postOrder(tLimitOrder));
        verifyNoMoreInteractions(mockTradeDataSource);
        expect(result, Right(tOrderResponseFull));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for known reasons',
      () async {
        //arrange
        when(mockTradeDataSource.postOrder(tLimitOrder)).thenThrow(BinanceException(message: "Too many new orders."));
        //act
        final result = await repository.postOrder(tLimitOrder);
        //assert
        expect(result, Left(ServerFailure(message: "Too many new orders.")));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for unknown reasons',
      () async {
        //arrange
        when(mockTradeDataSource.postOrder(tLimitOrder)).thenThrow(BinanceException());
        //act
        final result = await repository.postOrder(tLimitOrder);
        //assert
        expect(result, Left(ServerFailure()));
      },
    );
  });

  group('cancelOrder', () {
    final tCancelOrderRequest = CancelOrderRequest(symbol: 'BNBUSDT', orderId: 391921);
    final tCancelOrderResponse = CancelOrderResponse(
      symbol: 'BNBUSDT',
      origClientOrderId: '4fzUqS3X5SrRoPbFwgLh63',
      orderId: 3063604,
      orderListId: -1,
      clientOrderId: '2JW4xZGDmsKgJG7X84zwk3',
      price: Decimal.parse('100.00000000'),
      origQty: Decimal.parse('1000.00000000'),
      executedQty: Decimal.parse('83.68000000'),
      cummulativeQuoteQty: Decimal.parse('8368.00000000'),
      status: BinanceOrderStatus.CANCELED,
      timeInForce: BinanceOrderTimeInForce.GTC,
      type: BinanceOrderType.LIMIT,
      side: BinanceOrderSide.BUY,
    );

    test(
      'should return cancel order response when the call to data source is successful',
      () async {
        //arrange
        when(mockTradeDataSource.cancelOrder(tCancelOrderRequest)).thenAnswer((_) async => tCancelOrderResponse);
        //act
        final result = await repository.cancelOrder(tCancelOrderRequest);
        //assert
        expect(result, Right(tCancelOrderResponse));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for known reasons',
      () async {
        //arrange
        when(mockTradeDataSource.cancelOrder(tCancelOrderRequest)).thenThrow(BinanceException(message: "Too many requests."));
        //act
        final result = await repository.cancelOrder(tCancelOrderRequest);
        //assert
        expect(result, Left(ServerFailure(message: "Too many requests.")));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for unknown reasons',
      () async {
        //arrange
        when(mockTradeDataSource.cancelOrder(tCancelOrderRequest)).thenThrow(BinanceException());
        //act
        final result = await repository.cancelOrder(tCancelOrderRequest);
        //assert
        expect(result, Left(ServerFailure()));
      },
    );
  });
}
