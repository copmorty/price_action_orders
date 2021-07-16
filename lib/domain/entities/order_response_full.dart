import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order_fill.dart';
import 'order_response.dart';
import 'ticker.dart';

class OrderResponseFull extends OrderResponse {
  final Decimal/*!*/ price;
  final Decimal/*!*/ origQty;
  final Decimal/*!*/ executedQty;
  final Decimal/*!*/ cummulativeQuoteQty;
  final BinanceOrderStatus/*!*/ status;
  final BinanceOrderTimeInForce/*!*/ timeInForce;
  final BinanceOrderType/*!*/ type;
  final BinanceOrderSide/*!*/ side;
  final List<OrderFill>/*!*/ fills;

  OrderResponseFull({
    Ticker/*!*/ ticker,
    String/*!*/ symbol,
    int/*!*/ orderId,
    int/*!*/ orderListId,
    String/*!*/ clientOrderId,
    int/*!*/ transactTime,
    this.price,
    this.origQty,
    this.executedQty,
    this.cummulativeQuoteQty,
    this.status,
    this.timeInForce,
    this.type,
    this.side,
    this.fills,
  }) : super(
          ticker: ticker,
          symbol: symbol,
          orderId: orderId,
          orderListId: orderListId,
          clientOrderId: clientOrderId,
          transactTime: transactTime,
        );

  @override
  List<Object> get props => super.props..addAll([type, origQty, executedQty]);
}
