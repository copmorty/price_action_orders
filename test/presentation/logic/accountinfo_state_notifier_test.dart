import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';
import 'package:price_action_orders/domain/usecases/get_user_accountinfo.dart';
import 'package:price_action_orders/presentation/logic/accountinfo_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/userdata_stream.dart';

class MockGetAccountInfo extends Mock implements GetAccountInfo {}

class MockUserDataStream extends Mock implements UserDataStream {}

void main() {
  AccountInfoNotifier/*!*/ notifier;
  MockGetAccountInfo/*!*/ mockGetAccountInfo;
  MockUserDataStream/*!*/ mockUserDataStream;

  setUp(() {
    mockGetAccountInfo = MockGetAccountInfo();
    mockUserDataStream = MockUserDataStream();
    notifier = AccountInfoNotifier(getAccountInfo: mockGetAccountInfo, userDataStream: mockUserDataStream, init: false);
  });

  group('getAccountInfo', () {
    final tUserData = UserData(
      updateTime: 1625175255000,
      makerCommission: 15,
      takerCommission: 15,
      buyerCommission: 0,
      sellerCommission: 0,
      canTrade: true,
      canWithdraw: true,
      canDeposit: true,
      accountType: 'SPOT',
      balances: [
        Balance(asset: 'BTC', free: Decimal.parse('4723846.89208129'), locked: Decimal.parse('0.00000000')),
        Balance(asset: 'LTC', free: Decimal.parse('4763368.68006011'), locked: Decimal.parse('0.00000000')),
      ],
      permissions: ['SPOT'],
    );
    final tUserDataUpdated = UserData(
      updateTime: 1625175279239,
      makerCommission: 15,
      takerCommission: 15,
      buyerCommission: 0,
      sellerCommission: 0,
      canTrade: true,
      canWithdraw: true,
      canDeposit: true,
      accountType: 'SPOT',
      balances: [
        Balance(asset: 'BTC', free: Decimal.parse('4723846.89208129'), locked: Decimal.parse('0.00000000')),
        Balance(asset: 'LTC', free: Decimal.parse('4763368.68006011'), locked: Decimal.parse('0.00000000')),
        Balance(asset: 'ETH', free: Decimal.parse('10000.000000'), locked: Decimal.parse('0.000000')),
      ],
      permissions: ['SPOT'],
    );
    final tUserDataPayloadAccountUpdate = UserDataPayloadAccountUpdate(
      eventType: BinanceUserDataPayloadEventType.outboundAccountPosition,
      eventTime: 1625175279240,
      lastAccountUpdateTime: 1625175279239,
      changedBalances: [
        Balance(asset: 'ETH', free: Decimal.parse('10000.000000'), locked: Decimal.parse('0.000000')),
      ],
    );

    test(
      'should state AccountInfoInitial, AccountInfoLoading, and AccountInfoLoaded when initialization is successful',
      () async {
        //arrange
        final List<AccountInfoState> tStates = [
          AccountInfoInitial(),
          AccountInfoLoading(),
          AccountInfoLoaded(tUserData),
        ];
        final List<AccountInfoState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetAccountInfo.call(NoParams())).thenAnswer((_) async => Right(tUserData));
        when(mockUserDataStream.stream()).thenAnswer((_) => Stream<dynamic>.empty());
        //act
        await notifier.getAccountInfo();
        //assert
        verify(mockGetAccountInfo.call(NoParams()));
        verify(mockUserDataStream.stream());
        verifyNoMoreInteractions(mockGetAccountInfo);
        verifyNoMoreInteractions(mockUserDataStream);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state AccountInfoInitial, AccountInfoLoading, and AccountInfoError when initialization is unsuccessful',
      () async {
        //arrange
        final List<AccountInfoState> tStates = [
          AccountInfoInitial(),
          AccountInfoLoading(),
          AccountInfoError('The data is not available right now.'),
        ];
        final List<AccountInfoState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetAccountInfo.call(NoParams())).thenAnswer((_) async => Left(ServerFailure(message: 'The data is not available right now.')));
        when(mockUserDataStream.stream()).thenAnswer((_) => Stream<dynamic>.empty());
        //act
        await notifier.getAccountInfo();
        //assert
        verify(mockGetAccountInfo.call(NoParams()));
        verifyNoMoreInteractions(mockGetAccountInfo);
        verifyZeroInteractions(mockUserDataStream);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state an updated AccountInfoLoaded from the stream after successful initialization',
      () async {
        //arrange
        final List<AccountInfoState> tStates = [
          AccountInfoInitial(),
          AccountInfoLoading(),
          AccountInfoLoaded(tUserData),
          AccountInfoLoaded(tUserDataUpdated),
        ];
        final List<AccountInfoState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetAccountInfo.call(NoParams())).thenAnswer((_) async => Right(tUserData));
        when(mockUserDataStream.stream()).thenAnswer((_) => Stream<dynamic>.value(tUserDataPayloadAccountUpdate));
        //act
        await notifier.getAccountInfo();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetAccountInfo.call(NoParams()));
        verify(mockUserDataStream.stream());
        verifyNoMoreInteractions(mockGetAccountInfo);
        verifyNoMoreInteractions(mockUserDataStream);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state an AccountInfoError from the stream after successful initialization',
      () async {
        //arrange
        final List<AccountInfoState> tStates = [
          AccountInfoInitial(),
          AccountInfoLoading(),
          AccountInfoLoaded(tUserData),
          AccountInfoError('Account info not available right now.'),
        ];
        final List<AccountInfoState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetAccountInfo.call(NoParams())).thenAnswer((_) async => Right(tUserData));
        when(mockUserDataStream.stream()).thenAnswer((_) => Stream<dynamic>.error(Error()));
        //act
        await notifier.getAccountInfo();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetAccountInfo.call(NoParams()));
        verify(mockUserDataStream.stream());
        verifyNoMoreInteractions(mockGetAccountInfo);
        verifyNoMoreInteractions(mockUserDataStream);
        expect(actualStates, tStates);
      },
    );
  });
}
