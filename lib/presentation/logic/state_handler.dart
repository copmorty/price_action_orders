import 'package:price_action_orders/domain/entities/ticker.dart';
import 'accountinfo_state_notifier.dart';
import 'bookticker_state_notifier.dart';
import 'orders_state_notifier.dart';
import 'ticker_state_notifier.dart';
import 'tickerstats_state_notifier.dart';
import 'userdata_stream.dart';

class StateHandler {
  final UserDataStream _userDataStream;
  final AccountInfoNotifier _accountInfoNotifier;
  final OrdersNotifier _ordersNotifier;
  final BookTickerNotifier _bookTickerNotifier;
  final TickerNotifier _tickerNotifier;
  final TickerStatsNotifier _tickerStatsNotifier;

  StateHandler({
    required UserDataStream userDataStream,
    required AccountInfoNotifier accountInfoNotifier,
    required OrdersNotifier ordersNotifier,
    required BookTickerNotifier bookTickerNotifier,
    required TickerNotifier tickerNotifier,
    required TickerStatsNotifier tickerStatsNotifier,
  })   : _userDataStream = userDataStream,
        _accountInfoNotifier = accountInfoNotifier,
        _ordersNotifier = ordersNotifier,
        _bookTickerNotifier = bookTickerNotifier,
        _tickerNotifier = tickerNotifier,
        _tickerStatsNotifier = tickerStatsNotifier;

  Future<void> dispatchTicker(Ticker ticker) async {
    final tickerFound = await _tickerNotifier.setTicker(ticker);

    if (tickerFound) {
      _bookTickerNotifier.streamBookTicker(ticker);
      _tickerStatsNotifier.streamTickerStats(ticker);
    }
  }

  void _reloadUserStreams() {
    _userDataStream.initialization();
    _accountInfoNotifier.getAccountInfo();
    _ordersNotifier.getOpenOrders();
  }

  void reloadAccountInfo() => _reloadUserStreams();

  void reloadOrderLists() => _reloadUserStreams();
}
