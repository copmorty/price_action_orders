import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';

class MarketOrderModel extends MarketOrder {
  MarketOrderModel({
    @required String symbol,
    @required BinanceOrderSide side,
    BinanceOrderTimeInForce timeInForce,
    @required Decimal quantity,
    @required Decimal quoteOrderQty,
    Decimal price,
    String newClientOrderId,
    // Decimal stopPrice,
    // Decimal icebergQty,
    BinanceOrderResponseType newOrderRespType,
    int recvWindow,
    int timestamp,
  })  : assert(quantity == null || quoteOrderQty == null),
        super(
          symbol: symbol,
          side: side,
          timeInForce: timeInForce,
          quantity: quantity,
          quoteOrderQty: quoteOrderQty,
          price: price,
          newClientOrderId: newClientOrderId,
          // stopPrice: stopPrice,
          // icebergQty: icebergQty,
          newOrderRespType: newOrderRespType,
          recvWindow: recvWindow,
          timestamp: timestamp,
        );

  @override
  List<Object> get props => [symbol, side, type, timestamp, quantity, quoteOrderQty];

  factory MarketOrderModel.fromMarketOrder(MarketOrder marketOrder) {
    return MarketOrderModel(
      symbol: marketOrder.symbol,
      side: marketOrder.side,
      timeInForce: marketOrder.timeInForce,
      quantity: marketOrder.quantity,
      quoteOrderQty: marketOrder.quoteOrderQty,
      price: marketOrder.price,
      newClientOrderId: marketOrder.newClientOrderId,
      //stopPrice: marketOrder.stopPrice,
      //icebergQty: marketOrder.icebergQty,
      newOrderRespType: marketOrder.newOrderRespType,
      recvWindow: marketOrder.recvWindow,
      timestamp: marketOrder.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'side': side.toShortString(),
      'type': type.toShortString(),
      'timeInForce': timeInForce.toShortString(),
      'quantity': quantity.toString(),
      'quoteOrderQty': quoteOrderQty.toString(),
      'price': price.toString(),
      'newClientOrderId': newClientOrderId,
      //'stopPrice': stopPrice.toString(),
      //'icebergQty': icebergQty.toString(),
      'newOrderRespType': newOrderRespType.toShortString(),
      'recvWindow': recvWindow.toString(),
      'timestamp': timestamp.toString(),
    }..removeWhere((key, value) => value == null || value == 'null');
  }
}
