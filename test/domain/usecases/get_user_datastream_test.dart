import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';
import 'package:price_action_orders/domain/usecases/get_user_datastream.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  GetUserDataStream usecase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserDataStream(mockUserRepository);
  });

  Stream<dynamic> tStreamResponse;

  test(
    'should return a dynamic stream when the call to the repository is successful',
    () async {
      //arrange
      when(mockUserRepository.getUserDataStream()).thenAnswer((_) async => Right(tStreamResponse));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockUserRepository.getUserDataStream());
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Right(tStreamResponse));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockUserRepository.getUserDataStream()).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockUserRepository.getUserDataStream());
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
