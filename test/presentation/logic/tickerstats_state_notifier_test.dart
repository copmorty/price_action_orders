import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import 'package:price_action_orders/domain/usecases/market_get_tickerstats_stream_uc.dart';
import 'package:price_action_orders/domain/usecases/user_get_last_ticker_uc.dart';
import 'package:price_action_orders/presentation/logic/tickerstats_state_notifier.dart';
import 'tickerstats_state_notifier_test.mocks.dart';

@GenerateMocks([GetLastTicker, GetTickerStatsStream])
void main() {
  late TickerStatsNotifier notifier;
  late MockGetLastTicker mockGetLastTicker;
  late MockGetTickerStatsStream mockGetTickerStatsStream;

  setUp(() {
    mockGetLastTicker = MockGetLastTicker();
    mockGetTickerStatsStream = MockGetTickerStatsStream();
    notifier = TickerStatsNotifier(getLastTicker: mockGetLastTicker, getTickerStatsStream: mockGetTickerStatsStream, init: false);
  });

  group('initialization', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'BTC');

    test(
      'should call streamTickerStats when there is a ticker cached',
      () async {
        //arrange
        when(mockGetLastTicker.call(NoParams())).thenAnswer((_) async => Right(tTicker));
        when(mockGetTickerStatsStream.call(Params(tTicker))).thenAnswer((_) async => Right(Stream<TickerStats>.empty()));
        //act
        await notifier.initialization();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetLastTicker.call(NoParams()));
        verify(mockGetTickerStatsStream.call(Params(tTicker)));
        verifyNoMoreInteractions(mockGetLastTicker);
        verifyNoMoreInteractions(mockGetTickerStatsStream);
      },
    );

    test(
      'should not call streamTickerStats when there is no ticker cached',
      () async {
        //arrange
        when(mockGetLastTicker.call(NoParams())).thenAnswer((_) async => Left(CacheFailure()));
        //act
        await notifier.initialization();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetLastTicker.call(NoParams()));
        verifyNoMoreInteractions(mockGetLastTicker);
        verifyZeroInteractions(mockGetTickerStatsStream);
      },
    );
  });

  group('streamTickerStats', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'BTC');
    final tTickerStats = TickerStats(
      eventType: '24hrTicker',
      eventTime: 123456789,
      symbol: 'BNBBTC',
      priceChange: Decimal.parse('0.0015'),
      priceChangePercent: Decimal.parse('250.00'),
      weightedAveragePrice: Decimal.parse('0.0018'),
      firstTradeBefore: Decimal.parse('0.0009'),
      lastPrice: Decimal.parse('0.0025'),
      lastQuantity: Decimal.parse('10'),
      bestBidPrice: Decimal.parse('0.0024'),
      bestBidQuantity: Decimal.parse('10'),
      bestAskPrice: Decimal.parse('0.0026'),
      bestAskQuantity: Decimal.parse('100'),
      openPrice: Decimal.parse('0.0010'),
      highPrice: Decimal.parse('0.0025'),
      lowPrice: Decimal.parse('0.0010'),
      totalTradedBaseAssetVolume: Decimal.parse('10000'),
      totalTradedQuoteAssetVolume: Decimal.parse('18'),
      statisticsOpenTime: 0,
      statisticsCloseTime: 86400000,
      firstTradeId: 0,
      lastTradeId: 18150,
      totalNumberOfTrades: 18151,
      ticker: tTicker,
    );

    test(
      'should state TickerStatsInitial, TickerStatsLoading, and TickerStatsLoaded when the stream is successfully established',
      () async {
        //arrange
        final List<TickerStatsState> tStates = [
          TickerStatsInitial(),
          TickerStatsLoading(),
          TickerStatsLoaded(tTickerStats),
        ];
        final List<TickerStatsState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetTickerStatsStream.call(Params(tTicker))).thenAnswer((_) async => Right(Stream<TickerStats>.fromIterable([tTickerStats])));
        //act
        await notifier.streamTickerStats(tTicker);
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetTickerStatsStream.call(Params(tTicker)));
        verifyNoMoreInteractions(mockGetTickerStatsStream);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state TickerStatsInitial, TickerStatsLoading, and TickerStatsError when the stream could not be established',
      () async {
        //arrange
        final List<TickerStatsState> tStates = [
          TickerStatsInitial(),
          TickerStatsLoading(),
          TickerStatsError('Something went wrong.'),
        ];
        final List<TickerStatsState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetTickerStatsStream.call(Params(tTicker))).thenAnswer((_) async => Left(ServerFailure()));
        //act
        await notifier.streamTickerStats(tTicker);
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetTickerStatsStream.call(Params(tTicker)));
        verifyNoMoreInteractions(mockGetTickerStatsStream);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state TickerStatsInitial, TickerStatsLoading, and TickerStatsError when the stream emits an error',
      () async {
        //arrange
        final List<TickerStatsState> tStates = [
          TickerStatsInitial(),
          TickerStatsLoading(),
          TickerStatsError('Ticker data not available right now.'),
        ];
        final List<TickerStatsState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetTickerStatsStream.call(Params(tTicker))).thenAnswer((_) async => Right(Stream<TickerStats>.error(Error())));
        //act
        await notifier.streamTickerStats(tTicker);
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetTickerStatsStream.call(Params(tTicker)));
        verifyNoMoreInteractions(mockGetTickerStatsStream);
        expect(actualStates, tStates);
      },
    );
  });
}
