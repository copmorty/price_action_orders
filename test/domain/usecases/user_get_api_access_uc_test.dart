import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';
import 'package:price_action_orders/domain/usecases/user_get_api_access_uc.dart';
import 'user_get_api_access_uc_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetApiAccess usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetApiAccess(mockUserRepository);
  });

  final tAppMode = AppMode.TEST;
  final tApiAccess = ApiAccess(key: 'qwerty', secret: 'asdfgh');

  test(
    'should return ApiAccess when the call to the repository is successful',
    () async {
      //arrange
      when(mockUserRepository.getApiAccess(tAppMode)).thenAnswer((_) async => Right(tApiAccess));
      //act
      final result = await usecase(Params(tAppMode));
      //assert
      verify(mockUserRepository.getApiAccess(tAppMode));
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Right(tApiAccess));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockUserRepository.getApiAccess(tAppMode)).thenAnswer((_) async => Left(CacheFailure()));
      //act
      final result = await usecase(Params(tAppMode));
      //assert
      verify(mockUserRepository.getApiAccess(tAppMode));
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Left(CacheFailure()));
    },
  );
}
