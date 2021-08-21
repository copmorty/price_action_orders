import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import 'package:price_action_orders/domain/usecases/market_get_tickerstats_stream_uc.dart';
import 'package:price_action_orders/domain/usecases/user_get_last_ticker_uc.dart';

part 'tickerstats_state.dart';

class TickerStatsNotifier extends StateNotifier<TickerStatsState> {
  final GetLastTicker _getLastTicker;
  final GetTickerStatsStream _getTickerStatsStream;
  StreamSubscription? _subscription;

  TickerStatsNotifier({
    required GetLastTicker getLastTicker,
    required GetTickerStatsStream getTickerStatsStream,
    bool init = true,
  })  : _getLastTicker = getLastTicker,
        _getTickerStatsStream = getTickerStatsStream,
        super(TickerStatsInitial()) {
    if (init) initialization();
  }

  Future<void> initialization() async {
    final failureOrTicker = await _getLastTicker(NoParams());
    failureOrTicker.fold(
      (failure) => null, // No ticker cached yet
      (ticker) => streamTickerStats(ticker),
    );
  }

  Future<void> streamTickerStats(Ticker ticker) async {
    state = TickerStatsLoading();

    await _subscription?.cancel();
    final failureOrStream = await _getTickerStatsStream(Params(ticker));
    failureOrStream.fold(
      (failure) => state = TickerStatsError(failure.message),
      (stream) {
        _subscription = stream.listen(
          (tickerStats) => state = TickerStatsLoaded(tickerStats),
          onError: (error) {
            state = TickerStatsError('Ticker data not available right now.');
          },
          cancelOnError: true,
        );
      },
    );
  }
}
