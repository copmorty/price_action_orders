import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_orderupdate.dart';
import 'package:price_action_orders/domain/usecases/get_user_datastream.dart';
import 'package:price_action_orders/presentation/logic/userdata_stream.dart';
import 'userdata_stream_test.mocks.dart';

@GenerateMocks([GetUserDataStream])
void main() {
  late UserDataStream userDataStream;
  late MockGetUserDataStream mockGetUserDataStream;

  setUp(() {
    mockGetUserDataStream = MockGetUserDataStream();
    userDataStream = UserDataStream(getUserDataStream: mockGetUserDataStream, init: false);
  });

  group('initialization', () {
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
      orderRejectReason: 'NONE',
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
      'should set up a subscription when the server response is successful',
      () async {
        //arrange
        List<dynamic> tValues = [tOrderReport];
        List<dynamic> actualValues = [];
        userDataStream.stream().listen((data) => actualValues.add(data));
        when(mockGetUserDataStream.call(NoParams())).thenAnswer((_) async => Right(Stream<dynamic>.value(tOrderReport)));
        //act
        await userDataStream.initialization();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetUserDataStream.call(NoParams()));
        verifyNoMoreInteractions(mockGetUserDataStream);
        expect(actualValues, tValues);
      },
    );

    test(
      'should forward an error to the stream when the server response is unsuccessful',
      () async {
        //arrange
        List<dynamic> tValues = [ServerFailure()];
        List<dynamic> actualValues = [];
        userDataStream.stream().listen((data) => actualValues.add(data), onError: (err) => actualValues.add(err));
        when(mockGetUserDataStream.call(NoParams())).thenAnswer((_) async => Left(ServerFailure()));
        //act
        await userDataStream.initialization();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetUserDataStream.call(NoParams()));
        verifyNoMoreInteractions(mockGetUserDataStream);
        expect(actualValues, tValues);
      },
    );
  });
}
