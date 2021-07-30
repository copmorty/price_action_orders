import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/usecases/get_user_last_ticker.dart';
import 'package:price_action_orders/domain/usecases/set_user_last_ticker.dart';

part 'ticker_state.dart';

class TickerNotifier extends StateNotifier<TickerState> {
  final GetLastTicker _getLastTicker;
  final SetLastTicker _setLastTicker;

  TickerNotifier({
    required GetLastTicker getLastTicker,
    required SetLastTicker setLastTicker,
    bool init = true,
  })  : _getLastTicker = getLastTicker,
        _setLastTicker = setLastTicker,
        super(TickerInitial()) {
    if (init) initialization();
  }

  Future<void> initialization() async {
    final failureOrTicker = await _getLastTicker(NoParams());
    failureOrTicker.fold(
      (failure) => null, // No ticker cached yet
      (ticker) => state = TickerLoaded(ticker),
    );
  }

  void setLoading() {
    state = TickerLoading();
  }

  void setLoaded(Ticker ticker) {
    _setLastTicker(Params(ticker));
    state = TickerLoaded(ticker);
  }
}
