import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';
import 'package:price_action_orders/domain/usecases/user_get_last_ticker_uc.dart';
import 'user_get_last_ticker_uc_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetLastTicker usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetLastTicker(mockUserRepository);
  });

  final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');

  test(
    'should return the last ticker when the call to the repository is successful',
    () async {
      //arrange
      when(mockUserRepository.getLastTicker()).thenAnswer((_) async => Right(tTicker));
      //act
      final Either<Failure, Ticker>? result = await usecase(NoParams());
      //assert
      verify(mockUserRepository.getLastTicker());
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Right(tTicker));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful or there is no ticker in the cache',
    () async {
      //arrange
      when(mockUserRepository.getLastTicker()).thenAnswer((_) async => Left(CacheFailure()));
      //act
      final Either<Failure, Ticker>? result = await usecase(NoParams());
      //assert
      verify(mockUserRepository.getLastTicker());
      verifyNoMoreInteractions(mockUserRepository);
      expect(result, Left(CacheFailure()));
    },
  );
}
