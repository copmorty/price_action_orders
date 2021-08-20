import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import 'package:price_action_orders/domain/repositories/trade_repository.dart';
import 'package:price_action_orders/domain/usecases/trade_cancel_order_uc.dart';
import 'trade_cancel_order_uc_test.mocks.dart';

@GenerateMocks([TradeRepository])
void main() {
  late PostCancelOrder usecase;
  late MockTradeRepository mockTradeRepository;

  setUp(() {
    mockTradeRepository = MockTradeRepository();
    usecase = PostCancelOrder(mockTradeRepository);
  });

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
    'should return a cancel order response when the call to the repository is successful',
    () async {
      //arrange
      when(mockTradeRepository.postCancelOrder(tCancelOrderRequest)).thenAnswer((_) async => Right(tCancelOrderResponse));
      //act
      final Either<Failure, CancelOrderResponse>? result = await usecase(Params(tCancelOrderRequest));
      //assert
      verify(mockTradeRepository.postCancelOrder(tCancelOrderRequest));
      verifyNoMoreInteractions(mockTradeRepository);
      expect(result, Right(tCancelOrderResponse));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockTradeRepository.postCancelOrder(tCancelOrderRequest)).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final Either<Failure, CancelOrderResponse>? result = await usecase(Params(tCancelOrderRequest));
      //assert
      verify(mockTradeRepository.postCancelOrder(tCancelOrderRequest));
      verifyNoMoreInteractions(mockTradeRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
