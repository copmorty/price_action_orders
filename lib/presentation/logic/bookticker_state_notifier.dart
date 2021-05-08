import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/usecases/get_lastticker.dart';
import 'package:price_action_orders/domain/usecases/stream_bookticker.dart';
import 'package:price_action_orders/presentation/logic/orderconfig_state_notifier.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

part 'bookticker_state.dart';

class BookTickerNotifier extends StateNotifier<BookTickerState> {
  final GetLastTicker _getLastTicker;
  final StreamBookTicker _streamBookTicker;
  final OrderConfigNotifier _orderConfigNotifier;
  StreamSubscription _subscription;

  BookTickerNotifier({
    @required getLastTicker,
    @required streamBookTicker,
    @required orderConfigNotifier,
    bool start = true,
  })  : _getLastTicker = getLastTicker,
        _streamBookTicker = streamBookTicker,
        _orderConfigNotifier = orderConfigNotifier,
        super(BookTickerInitial()) {
    if (start) initialization();
  }

  Future<void> initialization() async {
    final failureOrTicker = await _getLastTicker(NoParams());
    failureOrTicker.fold(
      (failure) => print('No ticker cached yet'),
      (ticker) => streamBookTicker(ticker),
    );
  }

  Future<void> streamBookTicker(Ticker ticker) async {
    state = BookTickerLoading();

    await _subscription?.cancel();
    final failureOrStream = await _streamBookTicker(Params(ticker));
    failureOrStream.fold(
      (failure) => BookTickerError('idk'),
      (stream) {
        _orderConfigNotifier.setState(ticker);
        _subscription = stream.listen((event) => state = BookTickerLoaded(bookTicker: event));
      },
    );
  }
}
