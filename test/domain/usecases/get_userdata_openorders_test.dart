import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order.dart' as entity;
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';
import 'package:price_action_orders/domain/usecases/get_userdata_openorders.dart';

class MockUserDataRepository extends Mock implements UserDataRepository {}

void main() {
  GetOpenOrders usecase;
  MockUserDataRepository mockUserDataRepository;

  setUp(() {
    mockUserDataRepository = MockUserDataRepository();
    usecase = GetOpenOrders(mockUserDataRepository);
  });

  final List<entity.Order> tOpenOrders = [
    entity.Order(
      symbol: 'BNBUSDT',
      orderId: 3092189,
      orderListId: -1,
      clientOrderId: 'KhbCMI9VtpdRlOK5PVJ5JH',
      price: Decimal.parse('100.00000000'),
      origQty: Decimal.parse('1000.00000000'),
      executedQty: Decimal.parse('30.55000000'),
      cummulativeQuoteQty: Decimal.parse('3055.00000000'),
      status: BinanceOrderStatus.PARTIALLY_FILLED,
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

  test(
    'should return an (open) order list when the call to the repository is successful',
    () async {
      //arrange
      when(mockUserDataRepository.getOpenOrders()).thenAnswer((_) async => Right(tOpenOrders));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockUserDataRepository.getOpenOrders());
      verifyNoMoreInteractions(mockUserDataRepository);
      expect(result, Right(tOpenOrders));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockUserDataRepository.getOpenOrders()).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockUserDataRepository.getOpenOrders());
      verifyNoMoreInteractions(mockUserDataRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}