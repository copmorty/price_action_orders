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
import 'package:price_action_orders/domain/entities/order_request_market.dart';
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

  group('postLimitOrder', () {
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
        when(mockTradeDataSource.postLimitOrder(tLimitOrder)).thenAnswer((_) async => tOrderResponseFull);
        //act
        final result = await repository.postLimitOrder(tLimitOrder);
        //assert
        verify(mockTradeDataSource.postLimitOrder(tLimitOrder));
        verifyNoMoreInteractions(mockTradeDataSource);
        expect(result, Right(tOrderResponseFull));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for known reasons',
      () async {
        //arrange
        when(mockTradeDataSource.postLimitOrder(tLimitOrder)).thenThrow(BinanceException(message: "Too many new orders."));
        //act
        final result = await repository.postLimitOrder(tLimitOrder);
        //assert
        expect(result, Left(ServerFailure(message: "Too many new orders.")));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for unknown reasons',
      () async {
        //arrange
        when(mockTradeDataSource.postLimitOrder(tLimitOrder)).thenThrow(BinanceException());
        //act
        final result = await repository.postLimitOrder(tLimitOrder);
        //assert
        expect(result, Left(ServerFailure()));
      },
    );
  });

  group('postMarketOrder', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final MarketOrderRequest tMarketOrder = MarketOrderRequest(
      ticker: tTicker,
      side: BinanceOrderSide.BUY,
      quoteOrderQty: Decimal.parse('20'),
    );
    final tOrderResponseFull = OrderResponseFull(
      ticker: tTicker,
      symbol: 'BNBUSDT',
      orderId: 3065299,
      orderListId: -1,
      clientOrderId: 'T2Np7YlcUojhYefWoqqBga',
      transactTime: 1624117720140,
      price: Decimal.parse('0.00000000'),
      origQty: Decimal.parse('0.05000000'),
      executedQty: Decimal.parse('0.05000000'),
      cummulativeQuoteQty: Decimal.parse('16.96450000'),
      status: BinanceOrderStatus.FILLED,
      timeInForce: BinanceOrderTimeInForce.GTC,
      type: BinanceOrderType.MARKET,
      side: BinanceOrderSide.BUY,
      fills: [
        OrderFill(
          price: Decimal.parse('339.29000000'),
          quantity: Decimal.parse('0.05000000'),
          commission: Decimal.parse('0.00000000'),
          commissionAsset: 'BNB',
          tradeId: 392000,
        ),
      ],
    );

    test(
      'should return a full order response when the call to data source is successful',
      () async {
        //arrange
        when(mockTradeDataSource.postMarketOrder(tMarketOrder)).thenAnswer((_) async => tOrderResponseFull);
        //act
        final result = await repository.postMarketOrder(tMarketOrder);
        //assert
        verify(mockTradeDataSource.postMarketOrder(tMarketOrder));
        verifyNoMoreInteractions(mockTradeDataSource);
        expect(result, Right(tOrderResponseFull));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for known reasons',
      () async {
        //arrange
        when(mockTradeDataSource.postMarketOrder(tMarketOrder)).thenThrow(BinanceException(message: "Too many new orders."));
        //act
        final result = await repository.postMarketOrder(tMarketOrder);
        //assert
        expect(result, Left(ServerFailure(message: "Too many new orders.")));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for unknown reasons',
      () async {
        //arrange
        when(mockTradeDataSource.postMarketOrder(tMarketOrder)).thenThrow(BinanceException());
        //act
        final result = await repository.postMarketOrder(tMarketOrder);
        //assert
        expect(result, Left(ServerFailure()));
      },
    );
  });

  group('postCancelOrder', () {
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
        when(mockTradeDataSource.postCancelOrder(tCancelOrderRequest)).thenAnswer((_) async => tCancelOrderResponse);
        //act
        final result = await repository.postCancelOrder(tCancelOrderRequest);
        //assert
        expect(result, Right(tCancelOrderResponse));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for known reasons',
      () async {
        //arrange
        when(mockTradeDataSource.postCancelOrder(tCancelOrderRequest)).thenThrow(BinanceException(message: "Too many requests."));
        //act
        final result = await repository.postCancelOrder(tCancelOrderRequest);
        //assert
        expect(result, Left(ServerFailure(message: "Too many requests.")));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for unknown reasons',
      () async {
        //arrange
        when(mockTradeDataSource.postCancelOrder(tCancelOrderRequest)).thenThrow(BinanceException());
        //act
        final result = await repository.postCancelOrder(tCancelOrderRequest);
        //assert
        expect(result, Left(ServerFailure()));
      },
    );
  });
}
