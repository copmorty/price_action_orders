import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import 'package:price_action_orders/domain/usecases/user_check_account_status_uc.dart' as cas;
import 'package:price_action_orders/domain/usecases/user_clear_api_access_uc.dart' as caa;
import 'package:price_action_orders/domain/usecases/user_get_api_access_uc.dart' as gaa;
import 'package:price_action_orders/domain/usecases/user_store_api_access_uc.dart' as saa;
import 'package:price_action_orders/presentation/logic/auth_state_notifier.dart';
import 'auth_state_notifier_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<cas.CheckAccountStatus>(as: #MockCheckAccountStatus),
  MockSpec<caa.ClearApiAccess>(as: #MockClearApiAccess),
  MockSpec<gaa.GetApiAccess>(as: #MockGetApiAccess),
  MockSpec<saa.StoreApiAccess>(as: #MockStoreApiAccess),
])
void main() {
  late AuthNotifier notifier;
  late MockCheckAccountStatus mockCheckAccountStatus;
  late MockGetApiAccess mockGetApiAccess;
  late MockStoreApiAccess mockStoreApiAccess;
  late MockClearApiAccess mockClearApiAccess;

  setUp(() {
    mockCheckAccountStatus = MockCheckAccountStatus();
    mockGetApiAccess = MockGetApiAccess();
    mockStoreApiAccess = MockStoreApiAccess();
    mockClearApiAccess = MockClearApiAccess();
    notifier = AuthNotifier(
      checkAccountStatus: mockCheckAccountStatus,
      getApiAccess: mockGetApiAccess,
      storeApiAccess: mockStoreApiAccess,
      clearApiAccess: mockClearApiAccess,
      init: false,
    );
  });

  final AppMode tModeTest = AppMode.TEST;
  final AppMode tModeProd = AppMode.PRODUCTION;
  final String tKey = 'qwerty1QwErTyqwerty1QwErTyqwerty1QwErTyqwerty1QwErTyqwerty1QwErT';
  final String tSecret = 'asdfgh2ASdfGhasdfgh2ASdfGhasdfgh2ASdfGhasdfgh2ASdfGhasdfgh2ASdfG';
  final ApiAccess tApiAccess = ApiAccess(key: tKey, secret: tSecret);

  group('initialization', () {
    test(
      'should state AuthInitial, AuthLoading, and AuthLoaded(null, null) when there are no ApiAccess stored',
      () async {
        //arrange
        final List<AuthState> tStates = [
          AuthInitial(),
          AuthLoading(),
          AuthLoaded(),
        ];
        final List<AuthState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetApiAccess.call(gaa.Params(tModeTest))).thenAnswer((_) async => Left(CacheFailure()));
        when(mockGetApiAccess.call(gaa.Params(tModeProd))).thenAnswer((_) async => Left(CacheFailure()));
        //act
        await notifier.initialization();
        //assert
        verify(mockGetApiAccess.call(gaa.Params(tModeTest)));
        verify(mockGetApiAccess.call(gaa.Params(tModeProd)));
        verifyNoMoreInteractions(mockGetApiAccess);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state AuthInitial, AuthLoading, and AuthLoaded(not-null, null) when there is a TEST ApiAccess stored',
      () async {
        //arrange
        final List<AuthState> tStates = [
          AuthInitial(),
          AuthLoading(),
          AuthLoaded(testApiAccess: tApiAccess),
        ];
        final List<AuthState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetApiAccess.call(gaa.Params(tModeTest))).thenAnswer((_) async => Right(tApiAccess));
        when(mockGetApiAccess.call(gaa.Params(tModeProd))).thenAnswer((_) async => Left(CacheFailure()));
        //act
        await notifier.initialization();
        //assert
        verify(mockGetApiAccess.call(gaa.Params(tModeTest)));
        verify(mockGetApiAccess.call(gaa.Params(tModeProd)));
        verifyNoMoreInteractions(mockGetApiAccess);
        expect(actualStates, tStates);
      },
    );
  });

  group('storeCredentials', () {
    test(
      'should return true when the use case responds successfully',
      () async {
        //arrange
        when(mockStoreApiAccess.call(saa.Params(tModeTest, tKey, tSecret))).thenAnswer((_) async => Right(null));
        //act
        final result = await notifier.storeCredentials(tModeTest, tKey, tSecret);
        //assert
        verify(mockStoreApiAccess.call(saa.Params(tModeTest, tKey, tSecret)));
        verifyNoMoreInteractions(mockStoreApiAccess);
        expect(result, true);
      },
    );

    test(
      'should return false when the use case responds unsuccessful',
      () async {
        //arrange
        when(mockStoreApiAccess.call(saa.Params(tModeTest, tKey, tSecret))).thenAnswer((_) async => Left(ServerFailure()));
        //act
        final result = await notifier.storeCredentials(tModeTest, tKey, tSecret);
        //assert
        verify(mockStoreApiAccess.call(saa.Params(tModeTest, tKey, tSecret)));
        verifyNoMoreInteractions(mockStoreApiAccess);
        expect(result, false);
      },
    );
  });

  group('clearCredentials', () {
    test(
      'should return true when the use case responds successfully',
      () async {
        //arrange
        when(mockClearApiAccess.call(caa.Params(tModeTest))).thenAnswer((_) async => Right(null));
        //act
        final result = await notifier.clearCredentials(tModeTest);
        //assert
        verify(mockClearApiAccess.call(caa.Params(tModeTest)));
        verifyNoMoreInteractions(mockClearApiAccess);
        expect(result, true);
      },
    );

    test(
      'should return false when the use case responds unsuccessful',
      () async {
        //arrange
        when(mockClearApiAccess.call(caa.Params(tModeTest))).thenAnswer((_) async => Left(ServerFailure()));
        //act
        final result = await notifier.clearCredentials(tModeTest);
        //assert
        verify(mockClearApiAccess.call(caa.Params(tModeTest)));
        verifyNoMoreInteractions(mockClearApiAccess);
        expect(result, false);
      },
    );
  });

  group('checkAuthCredentials', () {
    test(
      'should return true when the use case responds successfully',
      () async {
        //arrange
        when(mockCheckAccountStatus.call(cas.Params(tModeTest, tKey, tSecret))).thenAnswer((_) async => Right(null));
        //act
        final result = await notifier.checkAuthCredentials(tModeTest, tKey, tSecret);
        //assert
        verify(mockCheckAccountStatus.call(cas.Params(tModeTest, tKey, tSecret)));
        verifyNoMoreInteractions(mockCheckAccountStatus);
        expect(result, true);
      },
    );

    test(
      'should return false when the use case responds unsuccessful',
      () async {
        //arrange
        when(mockCheckAccountStatus.call(cas.Params(tModeTest, tKey, tSecret))).thenAnswer((_) async => Left(ServerFailure()));
        //act
        final result = await notifier.checkAuthCredentials(tModeTest, tKey, tSecret);
        //assert
        verify(mockCheckAccountStatus.call(cas.Params(tModeTest, tKey, tSecret)));
        verifyNoMoreInteractions(mockCheckAccountStatus);
        expect(result, false);
      },
    );
  });
}
