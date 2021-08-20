import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/usecases/user_check_account_status_uc.dart';
import 'package:price_action_orders/presentation/logic/auth_handler.dart';
import 'auth_handler_test.mocks.dart';

@GenerateMocks([CheckAccountStatus])
void main() {
  late AuthHandler authHandler;
  late MockCheckAccountStatus mockCheckAccountStatus;

  setUp(() {
    mockCheckAccountStatus = MockCheckAccountStatus();
    authHandler = AuthHandler(checkAccountStatus: mockCheckAccountStatus);
  });

  group('checkAuthCredentials', () {
    final AppMode tmode = AppMode.TEST;
    final String tkey = 'HFKJGFbjhasfbka87b210dfgnskdgmhaskKJABhjabsf72anmbASDJFMNb4hg4L1';
    final String tsecret = 'Gjn8oJNHTkjnsgKHFKJQ3m1rkamnfbkgnKJBnwgdfhnmmsndfBJJyhgwajbnnafK';

    test(
      'should return true when the use case responds successfully',
      () async {
        //arrange
        when(mockCheckAccountStatus.call(Params(tmode, tkey, tsecret))).thenAnswer((_) async => Right(null));
        //act
        final result = await authHandler.checkAuthCredentials(tmode, tkey, tsecret);
        //assert
        verify(mockCheckAccountStatus.call(Params(tmode, tkey, tsecret)));
        verifyNoMoreInteractions(mockCheckAccountStatus);
        expect(result, true);
      },
    );

    test(
      'should return false when the use case responds unsuccessful',
      () async {
        //arrange
        when(mockCheckAccountStatus.call(Params(tmode, tkey, tsecret))).thenAnswer((_) async => Left(ServerFailure()));
        //act
        final result = await authHandler.checkAuthCredentials(tmode, tkey, tsecret);
        //assert
        verify(mockCheckAccountStatus.call(Params(tmode, tkey, tsecret)));
        verifyNoMoreInteractions(mockCheckAccountStatus);
        expect(result, false);
      },
    );
  });
}
