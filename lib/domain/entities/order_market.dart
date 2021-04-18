import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order.dart';

class MarketOrder extends Order {
  MarketOrder({
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
          type: BinanceOrderType.MARKET,
          timeInForce: timeInForce,
          quantity: quantity,
          quoteOrderQty: quoteOrderQty,
          price: price,
          newClientOrderId: newClientOrderId,
          // stopPrice: stopPrice,
          // icebergQty: icebergQty,
          newOrderRespType: newOrderRespType,
          recvWindow: recvWindow,
          timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        );

  @override
  List<Object> get props => [symbol, side, type, timestamp, quantity, quoteOrderQty];
}
