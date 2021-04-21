import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order.dart';
import 'ticker.dart';

class LimitOrder extends Order {
  LimitOrder({
    @required Ticker ticker,
    @required BinanceOrderSide side,
    @required BinanceOrderTimeInForce timeInForce,
    @required Decimal quantity,
    @required Decimal price,
    int timestamp,
  }) : super(
          ticker: ticker,
          side: side,
          type: BinanceOrderType.LIMIT,
          timeInForce: timeInForce,
          quantity: quantity,
          price: price,
          timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        );

  @override
  List<Object> get props => [symbol, side, type, timestamp];
}
