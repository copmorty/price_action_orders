import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';
import 'package:price_action_orders/domain/usecases/user_store_api_access_uc.dart';
import 'user_store_api_access_uc_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late StoreApiAccess usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = StoreApiAccess(mockUserRepository);
  });

  final tKey = 'qwerty';
  final tSecret = 'asdfgh';
  final tAppMode = AppMode.PRODUCTION;
  final tApiAccess = ApiAccess(key: tKey, secret: tSecret);

  test(
    'should return null when the call to the repository is successful',
    () async {
      //arrange
      when(mockUserRepository.storeApiAccess(tAppMode, tApiAccess)).thenAnswer((_) async => Right(null));
      //act
      final result = await usecase(Params(tAppMode, tKey, tSecret));
      //assert
      verify(mockUserRepository.storeApiAccess(tAppMode, tApiAccess));
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Right(null));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockUserRepository.storeApiAccess(tAppMode, tApiAccess)).thenAnswer((_) async => Left(CacheFailure()));
      //act
      final result = await usecase(Params(tAppMode, tKey, tSecret));
      //assert
      verify(mockUserRepository.storeApiAccess(tAppMode, tApiAccess));
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Left(CacheFailure()));
    },
  );
}
