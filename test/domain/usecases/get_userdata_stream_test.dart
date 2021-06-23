import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';
import 'package:price_action_orders/domain/usecases/get_userdata_stream.dart';

class MockUserDataRepository extends Mock implements UserDataRepository {}

void main() {
  GetUserDataStream usecase;
  MockUserDataRepository mockUserDataRepository;

  setUp(() {
    mockUserDataRepository = MockUserDataRepository();
    usecase = GetUserDataStream(mockUserDataRepository);
  });

  Stream<dynamic> tStreamResponse;

  test(
    'should return a dynamic stream when the call to the repository is successful',
    () async {
      //arrange
      when(mockUserDataRepository.getUserDataStream()).thenAnswer((_) async => Right(tStreamResponse));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockUserDataRepository.getUserDataStream());
      verifyNoMoreInteractions(mockUserDataRepository);
      expect(result, Right(tStreamResponse));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockUserDataRepository.getUserDataStream()).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockUserDataRepository.getUserDataStream());
      verifyNoMoreInteractions(mockUserDataRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
