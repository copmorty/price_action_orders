import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/market_respository.dart';
import 'package:price_action_orders/domain/usecases/get_market_last_ticker.dart';

class MockMarketRepository extends Mock implements MarketRepository {}

void main() {
  GetLastTicker usecase;
  MockMarketRepository mockMarketRepository;

  setUp(() {
    mockMarketRepository = MockMarketRepository();
    usecase = GetLastTicker(mockMarketRepository);
  });

  final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');

  test(
    'should return the last ticker when the call to the repository is successful',
    () async {
      //arrange
      when(mockMarketRepository.getLastTicker()).thenAnswer((_) async => Right(tTicker));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockMarketRepository.getLastTicker());
      verifyNoMoreInteractions(mockMarketRepository);
      expect(result, Right(tTicker));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful or there is no ticker in the cache',
    () async {
      //arrange
      when(mockMarketRepository.getLastTicker()).thenAnswer((_) async => Left(CacheFailure()));
      //act
      final result = await usecase(NoParams());
      //assert
      verify(mockMarketRepository.getLastTicker());
      verifyNoMoreInteractions(mockMarketRepository);
      expect(result, Left(CacheFailure()));
    },
  );
}
