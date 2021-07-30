import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import 'package:price_action_orders/domain/repositories/market_respository.dart';
import 'package:price_action_orders/domain/usecases/get_market_ticker_stats_stream.dart';
import 'get_market_bookticker_stream_test.mocks.dart';

@GenerateMocks([MarketRepository])
void main() {
  late GetTickerStatsStream usecase;
  late MockMarketRepository mockMarketRepository;

  setUp(() {
    mockMarketRepository = MockMarketRepository();
    usecase = GetTickerStatsStream(mockMarketRepository);
  });

  final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
  final Params tParams = Params(tTicker);
  final Stream<TickerStats> tTickerStatsStream = Stream<TickerStats>.empty();

  test(
    'should return tickerStats stream when the call to the repository is successful',
    () async {
      //arrange
      when(mockMarketRepository.getTickerStatsStream(tTicker)).thenAnswer((_) async => Right(tTickerStatsStream));
      //act
      final Either<Failure, Stream<TickerStats>>? result = await usecase(tParams);
      //assert
      verify(mockMarketRepository.getTickerStatsStream(tTicker));
      verifyNoMoreInteractions(mockMarketRepository);
      expect(result, Right(tTickerStatsStream));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockMarketRepository.getTickerStatsStream(tTicker)).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final Either<Failure, Stream<TickerStats>>? result = await usecase(tParams);
      //assert
      verify(mockMarketRepository.getTickerStatsStream(tTicker));
      verifyNoMoreInteractions(mockMarketRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
