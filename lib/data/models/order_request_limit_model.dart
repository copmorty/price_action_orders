import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class LimitOrderRequestModel extends LimitOrderRequest {
  LimitOrderRequestModel({
    @required Ticker ticker,
    @required BinanceOrderSide side,
    @required BinanceOrderTimeInForce timeInForce,
    @required Decimal quantity,
    @required Decimal price,
    int timestamp,
  }) : super(
          ticker: ticker,
          side: side,
          timeInForce: timeInForce,
          quantity: quantity,
          price: price,
          timestamp: timestamp,
        );

  @override
  List<Object> get props => [symbol, side, type, timestamp];

  factory LimitOrderRequestModel.fromLimitOrderRequest(LimitOrderRequest limiOrder) {
    return LimitOrderRequestModel(
      ticker: limiOrder.ticker,
      side: limiOrder.side,
      timeInForce: limiOrder.timeInForce,
      quantity: limiOrder.quantity,
      price: limiOrder.price,
      timestamp: limiOrder.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'side': side.toShortString(),
      'type': type.toShortString(),
      'timeInForce': timeInForce.toShortString(),
      'quantity': quantity.toString(),
      'price': price.toString(),
      'timestamp': timestamp.toString(),
    }..removeWhere((key, value) => value == null || value == 'null');
  }
}
