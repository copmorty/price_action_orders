import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order_request.dart';
import 'ticker.dart';

class LimitOrderRequest extends OrderRequest {
  LimitOrderRequest({
    Ticker/*!*/ ticker,
    BinanceOrderSide/*!*/ side,
    BinanceOrderTimeInForce/*!*/ timeInForce,
    Decimal/*!*/ quantity,
    Decimal/*!*/ price,
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
}
