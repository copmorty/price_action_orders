import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';
import 'package:price_action_orders/domain/usecases/set_user_last_ticker.dart';

import 'set_user_last_ticker_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late SetLastTicker usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = SetLastTicker(mockUserRepository);
  });

  final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');

  test(
    'should return the null when the call to the repository is successful',
    () async {
      //arrange
      when(mockUserRepository.setLastTicker(tTicker)).thenAnswer((_) async => Right(null));
      //act
      final Either<Failure, Null>? result = await usecase(Params(tTicker));
      //assert
      verify(mockUserRepository.setLastTicker(tTicker));
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Right(null));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockUserRepository.setLastTicker(tTicker)).thenAnswer((_) async => Left(CacheFailure()));
      //act
      final Either<Failure, Null>? result = await usecase(Params(tTicker));
      //assert
      verify(mockUserRepository.setLastTicker(tTicker));
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Left(CacheFailure()));
    },
  );
}
