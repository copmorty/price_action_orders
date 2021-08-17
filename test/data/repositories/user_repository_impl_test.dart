import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/datasources/user_datasource.dart';
import 'package:price_action_orders/data/repositories/user_repository_impl.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/order.dart' as entity;
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([UserDataSource])
void main() {
  late UserRepositoryImpl repository;
  late MockUserDataSource mockUserDataSource;

  setUp(() {
    mockUserDataSource = MockUserDataSource();
    repository = UserRepositoryImpl(mockUserDataSource);
  });

  group('getAccountInfo', () {
    final UserData tUserData = UserData(
      updateTime: 1624137413896,
      makerCommission: 0,
      takerCommission: 0,
      buyerCommission: 0,
      sellerCommission: 0,
      canTrade: true,
      canWithdraw: false,
      canDeposit: false,
      accountType: 'SPOT',
      balances: [
        Balance(asset: 'BNB', free: Decimal.parse('3206.29000000'), locked: Decimal.parse('0.00000000')),
        Balance(asset: 'BTC', free: Decimal.parse('1.00000000'), locked: Decimal.parse('0.00000000')),
        Balance(asset: 'USDT', free: Decimal.parse('802326.89433047'), locked: Decimal.parse('96945.00000000')),
      ],
      permissions: ['SPOT'],
    );

    test(
      'should return user data when the call to data source is successful',
      () async {
        //arrange
        when(mockUserDataSource.getAccountInfo()).thenAnswer((_) async => tUserData);
        //act
        final result = await repository.getAccountInfo();
        //assert
        expect(result, Right(tUserData));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for known reasons',
      () async {
        //arrange
        when(mockUserDataSource.getAccountInfo()).thenThrow(BinanceException(message: "Internal error, unable to process your request. Please try again."));
        //act
        final result = await repository.getAccountInfo();
        //assert
        expect(result, Left(ServerFailure(message: "Internal error, unable to process your request. Please try again.")));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for unknown reasons',
      () async {
        //arrange
        when(mockUserDataSource.getAccountInfo()).thenThrow(BinanceException());
        //act
        final result = await repository.getAccountInfo();
        //assert
        expect(result, Left(ServerFailure()));
      },
    );
  });

  group('getOpenOrders', () {
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
      'should return a list of open orders when the call to data source is succssesful',
      () async {
        //arrange
        when(mockUserDataSource.getOpenOrders()).thenAnswer((_) async => tOpenOrders);
        //act
        final result = await repository.getOpenOrders();
        //assert
        expect(result, Right(tOpenOrders));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for known reasons',
      () async {
        //arrange
        when(mockUserDataSource.getOpenOrders()).thenThrow(BinanceException(message: "Internal error, unable to process your request. Please try again."));
        //act
        final result = await repository.getOpenOrders();
        //assert
        expect(result, Left(ServerFailure(message: "Internal error, unable to process your request. Please try again.")));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for unknown reasons',
      () async {
        //arrange
        when(mockUserDataSource.getOpenOrders()).thenThrow(BinanceException());
        //act
        final result = await repository.getOpenOrders();
        //assert
        expect(result, Left(ServerFailure()));
      },
    );
  });

  group('getUserDataStream', () {
    Stream<dynamic> tStreamResponse = Stream<dynamic>.empty();

    test(
      'should return a dynamic stream when the call to data source is successful',
      () async {
        //arrange
        when(mockUserDataSource.getUserDataStream()).thenAnswer(((_) async => tStreamResponse));
        //act
        final result = await repository.getUserDataStream();
        //assert
        expect(result, Right(tStreamResponse));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful',
      () async {
        //arrange
        when(mockUserDataSource.getUserDataStream()).thenThrow(ServerException(message: "Could not obtain UserData stream."));
        //act
        final result = await repository.getUserDataStream();
        //assert
        expect(result, Left(ServerFailure(message: "Could not obtain UserData stream.")));
      },
    );
  });

  group('getLastTicker', () {
    final Ticker tTicker = Ticker(baseAsset: 'BTC', quoteAsset: 'USDT');

    test(
      'should return a ticker when the call to data source is successful',
      () async {
        //arrange
        when(mockUserDataSource.getLastTicker()).thenAnswer((_) async => tTicker);
        //act
        final result = await repository.getLastTicker();
        //assert
        verify(mockUserDataSource.getLastTicker());
        verifyNoMoreInteractions(mockUserDataSource);
        expect(result, Right(tTicker));
      },
    );

    test(
      'should return cache failure when the call to data source is unsuccessful',
      () async {
        //arrange
        when(mockUserDataSource.getLastTicker()).thenThrow(CacheException());
        //act
        final result = await repository.getLastTicker();
        //assert
        verify(mockUserDataSource.getLastTicker());
        verifyNoMoreInteractions(mockUserDataSource);
        expect(result, Left(CacheFailure()));
      },
    );
  });

  group('setLastTicker', () {
    final Ticker tTicker = Ticker(baseAsset: 'BTC', quoteAsset: 'USDT');

    test(
      'should return null when the call to data source is successful',
      () async {
        //act
        final result = await repository.setLastTicker(tTicker);
        //assert
        expect(result, Right(null));
      },
    );

    test(
      'should return cache failure when the call to data source is unsuccessful',
      () async {
        //arrange
        when(mockUserDataSource.cacheLastTicker(tTicker)).thenThrow(Exception());
        //act
        final result = await repository.setLastTicker(tTicker);
        //assert
        expect(result, Left(CacheFailure()));
      },
    );
  });

  group('checkAccountStatus', () {
    final AppMode tmode = AppMode.TEST;
    final String tkey = 'HFKJGFbjhasfbka87b210dfgnskdgmhaskKJABhjabsf72anmbASDJFMNb4hg4L1';
    final String tsecret = 'Gjn8oJNHTkjnsgKHFKJQ3m1rkamnfbkgnKJBnwgdfhnmmsndfBJJyhgwajbnnafK';

    test(
      'should return null when the call to data source is successful',
      () async {
        //arrange
        when(mockUserDataSource.checkAccountStatus(tmode, tkey, tsecret)).thenAnswer((realInvocation) async => null);
        //act
        final result = await repository.checkAccountStatus(tmode, tkey, tsecret);
        //assert
        expect(result, Right(null));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for known reasons',
      () async {
        //arrange
        when(mockUserDataSource.checkAccountStatus(tmode, tkey, tsecret))
            .thenThrow(BinanceException(message: "Internal error, unable to process your request. Please try again."));
        //act
        final result = await repository.checkAccountStatus(tmode, tkey, tsecret);
        //assert
        expect(result, Left(ServerFailure(message: "Internal error, unable to process your request. Please try again.")));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful for unknown reasons',
      () async {
        //arrange
        when(mockUserDataSource.checkAccountStatus(tmode, tkey, tsecret)).thenThrow(BinanceException());
        //act
        final result = await repository.checkAccountStatus(tmode, tkey, tsecret);
        //assert
        expect(result, Left(ServerFailure()));
      },
    );
  });
}
