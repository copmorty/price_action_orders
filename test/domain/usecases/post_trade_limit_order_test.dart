import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/trade_repository.dart';
import 'package:price_action_orders/domain/usecases/post_trade_limit_order.dart';
import 'post_trade_limit_order_test.mocks.dart';

@GenerateMocks([TradeRepository])
void main() {
  late PostLimitOrder usecase;
  late MockTradeRepository mockTradeRepository;

  setUp(() {
    mockTradeRepository = MockTradeRepository();
    usecase = PostLimitOrder(mockTradeRepository);
  });

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
    'should return a full order response when the call to the repository is successful',
    () async {
      //arrange
      when(mockTradeRepository.postLimitOrder(tLimitOrder)).thenAnswer((_) async => Right(tOrderResponseFull));
      //act
      final Either<Failure, OrderResponseFull>? result = await usecase(Params(tLimitOrder));
      //assert
      verify(mockTradeRepository.postLimitOrder(tLimitOrder));
      verifyNoMoreInteractions(mockTradeRepository);
      expect(result, Right(tOrderResponseFull));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockTradeRepository.postLimitOrder(tLimitOrder)).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final Either<Failure, OrderResponseFull>? result = await usecase(Params(tLimitOrder));
      //assert
      verify(mockTradeRepository.postLimitOrder(tLimitOrder));
      verifyNoMoreInteractions(mockTradeRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
