import 'package:price_action_orders/domain/entities/ticker.dart';
import 'accountinfo_state_notifier.dart';
import 'bookticker_state_notifier.dart';
import 'orders_state_notifier.dart';
import 'tickerstats_state_notifier.dart';
import 'userdata_stream.dart';

class StateHandler {
  final UserDataStream _userDataStream;
  final AccountInfoNotifier _accountInfoNotifier;
  final OrdersNotifier _ordersNotifier;
  final BookTickerNotifier _bookTickerNotifier;
  final TickerStatsNotifier _tickerStatsNotifier;

  StateHandler({
    required UserDataStream userDataStream,
    required AccountInfoNotifier accountInfoNotifier,
    required OrdersNotifier ordersNotifier,
    required BookTickerNotifier bookTickerNotifier,
    required TickerStatsNotifier tickerStatsNotifier,
  })   : _userDataStream = userDataStream,
        _accountInfoNotifier = accountInfoNotifier,
        _ordersNotifier = ordersNotifier,
        _bookTickerNotifier = bookTickerNotifier,
        _tickerStatsNotifier = tickerStatsNotifier;

  void dispatchTicker(Ticker ticker) {
    _bookTickerNotifier.streamBookTicker(ticker);
    _tickerStatsNotifier.streamTickerStats(ticker);
  }

  void _reloadUserStreams() {
    _userDataStream.initialization();
    _accountInfoNotifier.getAccountInfo();
    _ordersNotifier.getOpenOrders();
  }

  void reloadAccountInfo() => _reloadUserStreams();

  void reloadOrderLists() => _reloadUserStreams();
}
