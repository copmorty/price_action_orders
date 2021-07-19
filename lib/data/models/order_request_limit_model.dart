import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class LimitOrderRequestModel extends LimitOrderRequest {
  LimitOrderRequestModel({
    required Ticker ticker,
    required BinanceOrderSide side,
    required BinanceOrderTimeInForce timeInForce,
    required Decimal quantity,
    required Decimal price,
    int? timestamp,
  }) : super(
          ticker: ticker,
          side: side,
          timeInForce: timeInForce,
          quantity: quantity,
          price: price,
          timestamp: timestamp,
        );

  factory LimitOrderRequestModel.fromLimitOrderRequest(LimitOrderRequest limitOrderRequest) {
    return LimitOrderRequestModel(
      ticker: limitOrderRequest.ticker,
      side: limitOrderRequest.side,
      timeInForce: limitOrderRequest.timeInForce!,
      quantity: limitOrderRequest.quantity!,
      price: limitOrderRequest.price!,
      timestamp: limitOrderRequest.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'side': side.toShortString(),
      'type': type.toShortString(),
      'timeInForce': timeInForce!.toShortString(),
      'quantity': quantity.toString(),
      'price': price.toString(),
      'timestamp': timestamp.toString(),
    }..removeWhere((key, value) => value == null || value == 'null');
  }
}
