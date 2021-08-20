import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';
import 'package:price_action_orders/domain/usecases/user_check_account_status_uc.dart';
import 'user_check_account_status_uc_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late CheckAccountStatus usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = CheckAccountStatus(mockUserRepository);
  });

    final AppMode tmode = AppMode.TEST;
    final String tkey = 'HFKJGFbjhasfbka87b210dfgnskdgmhaskKJABhjabsf72anmbASDJFMNb4hg4L1';
    final String tsecret = 'Gjn8oJNHTkjnsgKHFKJQ3m1rkamnfbkgnKJBnwgdfhnmmsndfBJJyhgwajbnnafK';

  test(
    'should return null when the call to the repository is successful',
    () async {
      //arrange
      when(mockUserRepository.checkAccountStatus(tmode, tkey, tsecret)).thenAnswer((_) async => Right(null));
      //act
      final Either<Failure, Null>? result = await usecase(Params(tmode, tkey, tsecret));
      //assert
      verify(mockUserRepository.checkAccountStatus(tmode, tkey, tsecret));
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Right(null));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockUserRepository.checkAccountStatus(tmode, tkey, tsecret)).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final Either<Failure, Null>? result = await usecase(Params(tmode, tkey, tsecret));
      //assert
      verify(mockUserRepository.checkAccountStatus(tmode, tkey, tsecret));
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
