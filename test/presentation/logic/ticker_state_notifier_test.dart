import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/usecases/get_user_last_ticker.dart';
import 'package:price_action_orders/domain/usecases/set_user_last_ticker.dart';
import 'package:price_action_orders/presentation/logic/ticker_state_notifier.dart';
import 'ticker_state_notifier_test.mocks.dart';

@GenerateMocks([GetLastTicker, SetLastTicker])
void main() {
  late TickerNotifier notifier;
  late MockGetLastTicker mockGetLastTicker;
  late MockSetLastTicker mockSetLastTicker;

  setUp(() {
    mockGetLastTicker = MockGetLastTicker();
    mockSetLastTicker = MockSetLastTicker();
    notifier = TickerNotifier(getLastTicker: mockGetLastTicker, setLastTicker: mockSetLastTicker, init: false);
  });

  group('initialization', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');

    test(
      'should state TickerInitial and TickerLoaded when there is a ticker cached',
      () async {
        //arrange
        final List<TickerState> tStates = [
          TickerInitial(),
          TickerLoaded(tTicker),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetLastTicker.call(NoParams())).thenAnswer((_) async => Right(tTicker));
        //act
        await notifier.initialization();
        //assert
        verify(mockGetLastTicker.call(NoParams()));
        verifyNoMoreInteractions(mockGetLastTicker);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state TickerInitial when there is no ticker cached',
      () async {
        //arrange
        final List<TickerState> tStates = [
          TickerInitial(),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetLastTicker.call(NoParams())).thenAnswer((_) async => Left(CacheFailure()));
        //act
        await notifier.initialization();
        //assert
        verify(mockGetLastTicker.call(NoParams()));
        verifyNoMoreInteractions(mockGetLastTicker);
        expect(actualStates, tStates);
      },
    );
  });

  group('setLoading', () {
    test(
      'should state TickerInitial and TickerLoading after first time call',
      () async {
        //arrange
        final List<TickerState> tStates = [
          TickerInitial(),
          TickerLoading(),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        //act
        notifier.setLoading();
        //assert
        expect(actualStates, tStates);
      },
    );
  });

  group('setLoaded', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');

    test(
      'should make a call to set the last ticker',
      () async {
        //arrange
        when(mockSetLastTicker.call(Params(tTicker))).thenAnswer((_) async => Right(null));
        //act
        notifier.setLoaded(tTicker);
        //assert
        verify(mockSetLastTicker.call(Params(tTicker)));
      },
    );

    test(
      'should state TickerInitial and TickerLoaded after first time call',
      () async {
        //arrange
        final List<TickerState> tStates = [
          TickerInitial(),
          TickerLoaded(tTicker),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockSetLastTicker.call(Params(tTicker))).thenAnswer((_) async => Right(null));
        //act
        notifier.setLoaded(tTicker);
        //assert
        expect(actualStates, tStates);
      },
    );
  });
}
