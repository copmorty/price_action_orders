import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order_request.dart';
import 'ticker.dart';

class StopLimitOrderRequest extends OrderRequest {
  StopLimitOrderRequest({
    required Ticker ticker,
    required BinanceOrderSide side,
    required BinanceOrderTimeInForce timeInForce,
    required Decimal quantity,
    required Decimal price,
    required Decimal stopPrice,
    int? timestamp,
  }) : super(
          ticker: ticker,
          side: side,
          type: BinanceOrderType.LIMIT,
          timeInForce: timeInForce,
          quantity: quantity,
          price: price,
          stopPrice: stopPrice,
          timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        );
}
