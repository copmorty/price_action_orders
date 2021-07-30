import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/usecases/get_user_last_ticker.dart';
import 'package:price_action_orders/domain/usecases/get_market_bookticker_stream.dart';

part 'bookticker_state.dart';

class BookTickerNotifier extends StateNotifier<BookTickerState> {
  final GetLastTicker _getLastTicker;
  final GetBookTickerStream _getBookTickerStream;
  StreamSubscription? _subscription;

  BookTickerNotifier({
    required GetLastTicker getLastTicker,
    required GetBookTickerStream getBookTickerStream,
    bool init = true,
  })  : _getLastTicker = getLastTicker,
        _getBookTickerStream = getBookTickerStream,
        super(BookTickerInitial()) {
    if (init) initialization();
  }

  Future<void> initialization() async {
    final failureOrTicker = await _getLastTicker(NoParams());
    failureOrTicker.fold(
      (failure) => null, // No ticker cached yet
      (ticker) => streamBookTicker(ticker),
    );
  }

  Future<void> streamBookTicker(Ticker ticker) async {
    state = BookTickerLoading();

    await _subscription?.cancel();
    final failureOrStream = await _getBookTickerStream(Params(ticker));
    failureOrStream.fold(
      (failure) => state = BookTickerError(failure.message),
      (stream) {
        _subscription = stream.listen(
          (bookTicker) => state = BookTickerLoaded(bookTicker),
          onError: (error) {
            state = BookTickerError('Market data not available right now.');
          },
          cancelOnError: true,
        );
      },
    );
  }
}
