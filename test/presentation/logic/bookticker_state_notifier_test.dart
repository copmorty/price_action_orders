import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/usecases/get_market_bookticker_stream.dart';
import 'package:price_action_orders/domain/usecases/get_market_last_ticker.dart';
import 'package:price_action_orders/presentation/logic/bookticker_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/orderconfig_state_notifier.dart';

class MockGetLastTicker extends Mock implements GetLastTicker {}

class MockGetBookTickerStream extends Mock implements GetBookTickerStream {}

class MockOrderConfigNotifier extends Mock implements OrderConfigNotifier {}

void main() {
  BookTickerNotifier notifier;
  MockGetLastTicker mockGetLastTicker;
  MockGetBookTickerStream mockGetBookTickerStream;
  MockOrderConfigNotifier mockOrderConfigNotifier;

  setUp(() {
    mockGetLastTicker = MockGetLastTicker();
    mockGetBookTickerStream = MockGetBookTickerStream();
    mockOrderConfigNotifier = MockOrderConfigNotifier();
    notifier = BookTickerNotifier(
        getLastTicker: mockGetLastTicker, getBookTickerStream: mockGetBookTickerStream, orderConfigNotifier: mockOrderConfigNotifier, start: false);
  });

  group('initialization', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final tBookTicker = BookTicker(
      updatedId: 1623853890857,
      symbol: 'BNBUSDT',
      ticker: tTicker,
      bidPrice: Decimal.parse('353'),
      bidQty: Decimal.parse('1.42'),
      askPrice: Decimal.parse('353.45'),
      askQty: Decimal.parse('1.42'),
    );

    test(
      'should not call streamBookTicker when there is no ticker cached',
      () async {
        //arrange
        when(mockGetLastTicker.call(NoParams())).thenAnswer((_) async => Left(CacheFailure()));
        //act
        await notifier.initialization();
        //assert
        verify(mockGetLastTicker.call(NoParams()));
        verifyNoMoreInteractions(mockGetLastTicker);
        verifyZeroInteractions(mockGetBookTickerStream);
        verifyZeroInteractions(mockOrderConfigNotifier);
      },
    );

    test(
      'should call streamBookTicker when there is a ticker cached',
      () async {
        when(mockGetLastTicker.call(NoParams())).thenAnswer((_) async => Right(tTicker));
        when(mockGetBookTickerStream.call(Params(tTicker))).thenAnswer((_) async => Right(Stream<BookTicker>.fromIterable([tBookTicker])));
        //act
        await notifier.initialization();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetLastTicker.call(NoParams()));
        verify(mockGetBookTickerStream.call(Params(tTicker)));
        verifyNoMoreInteractions(mockGetLastTicker);
        verifyNoMoreInteractions(mockGetBookTickerStream);
      },
    );
  });

  group('streamBookTicker', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final tBookTicker = BookTicker(
      updatedId: 1623853890857,
      symbol: 'BNBUSDT',
      ticker: tTicker,
      bidPrice: Decimal.parse('353'),
      bidQty: Decimal.parse('1.42'),
      askPrice: Decimal.parse('353.45'),
      askQty: Decimal.parse('1.42'),
    );

    test(
      'should state BookTickerInitial, BookTickerLoading, and BookTickerLoaded when the stream is successfully established',
      () async {
        //arrange
        final List<BookTickerState> tStates = [
          BookTickerInitial(),
          BookTickerLoading(),
          BookTickerLoaded(tBookTicker),
        ];
        final List<BookTickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetBookTickerStream.call(Params(tTicker))).thenAnswer((_) async => Right(Stream<BookTicker>.fromIterable([tBookTicker])));
        //act
        await notifier.streamBookTicker(tTicker);
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetBookTickerStream.call(Params(tTicker)));
        verify(mockOrderConfigNotifier.setState(tTicker));
        verifyNoMoreInteractions(mockGetBookTickerStream);
        verifyNoMoreInteractions(mockOrderConfigNotifier);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state BookTickerInitial, BookTickerLoading, and BookTickerError when the stream could not be established',
      () async {
        //arrange
        final List<BookTickerState> tStates = [
          BookTickerInitial(),
          BookTickerLoading(),
          BookTickerError('Something went wrong.'),
        ];
        final List<BookTickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetBookTickerStream.call(Params(tTicker))).thenAnswer((_) async => Left(ServerFailure()));
        //act
        await notifier.streamBookTicker(tTicker);
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetBookTickerStream.call(Params(tTicker)));
        verifyNoMoreInteractions(mockGetBookTickerStream);
        verifyZeroInteractions(mockOrderConfigNotifier);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state BookTickerInitial, BookTickerLoading, and BookTickerError when the stream emits an error',
      () async {
        //arrange
        final List<BookTickerState> tStates = [
          BookTickerInitial(),
          BookTickerLoading(),
          BookTickerError('Market data not available right now.'),
        ];
        final List<BookTickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetBookTickerStream.call(Params(tTicker))).thenAnswer((_) async => Right(Stream<BookTicker>.error(Error())));
        //act
        await notifier.streamBookTicker(tTicker);
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetBookTickerStream.call(Params(tTicker)));
        verify(mockOrderConfigNotifier.setState(tTicker));
        verifyNoMoreInteractions(mockGetBookTickerStream);
        verifyNoMoreInteractions(mockOrderConfigNotifier);
        expect(actualStates, tStates);
      },
    );
  });
}
