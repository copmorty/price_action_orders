import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_request_stop_limit.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class StopLimitOrderRequestModel extends StopLimitOrderRequest {
  StopLimitOrderRequestModel({
    required Ticker ticker,
    required BinanceOrderSide side,
    required BinanceOrderTimeInForce timeInForce,
    required BinanceOrderType type,
    required Decimal quantity,
    required Decimal price,
    required Decimal stopPrice,
    int? timestamp,
  }) : super(
          ticker: ticker,
          side: side,
          timeInForce: timeInForce,
          type: type,
          quantity: quantity,
          price: price,
          stopPrice: stopPrice,
          timestamp: timestamp,
        );

  factory StopLimitOrderRequestModel.fromStopLimitOrderRequest(StopLimitOrderRequest stopLimitOrderRequest) {
    return StopLimitOrderRequestModel(
      ticker: stopLimitOrderRequest.ticker,
      side: stopLimitOrderRequest.side,
      type: stopLimitOrderRequest.type,
      timeInForce: stopLimitOrderRequest.timeInForce!,
      quantity: stopLimitOrderRequest.quantity!,
      price: stopLimitOrderRequest.price!,
      stopPrice: stopLimitOrderRequest.stopPrice!,
      timestamp: stopLimitOrderRequest.timestamp,
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
      'stopPrice': stopPrice.toString(),
      'newOrderRespType': newOrderRespType!.toShortString(),
      'timestamp': timestamp.toString(),
    }..removeWhere((key, value) => value == null || value == 'null');
  }
}
