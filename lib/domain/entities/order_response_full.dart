import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import 'package:price_action_orders/domain/entities/order_response.dart';
import 'package:meta/meta.dart';

class OrderResponseFull extends OrderResponse {
  final String price;
  final String origQty;
  final String executedQty;
  final String cummulativeQuoteQty;
  final BinanceOrderStatus status;
  final BinanceOrderTimeInForce timeInForce;
  final BinanceOrderType type;
  final BinanceOrderSide side;
  final List<OrderFill> fills;

  OrderResponseFull({
    @required String symbol,
    @required int orderId,
    @required int orderListId,
    @required String clientOrderId,
    @required int transactTime,
    @required this.price,
    @required this.origQty,
    @required this.executedQty,
    @required this.cummulativeQuoteQty,
    @required this.status,
    @required this.timeInForce,
    @required this.type,
    @required this.side,
    @required this.fills,
  }) : super(symbol: symbol, orderId: orderId, orderListId: orderListId, clientOrderId: clientOrderId, transactTime: transactTime);

  @override
  List<Object> get props => [orderId];
}
