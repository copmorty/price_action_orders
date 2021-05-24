import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order_fill.dart';
import 'order_response.dart';
import 'ticker.dart';

class OrderResponseFull extends OrderResponse {
  final Decimal price;
  final Decimal origQty;
  final Decimal executedQty;
  final Decimal cummulativeQuoteQty;
  final BinanceOrderStatus status;
  final BinanceOrderTimeInForce timeInForce;
  final BinanceOrderType type;
  final BinanceOrderSide side;
  final List<OrderFill> fills;

  OrderResponseFull({
    @required Ticker ticker,
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
  }) : super(
          ticker: ticker,
          symbol: symbol,
          orderId: orderId,
          orderListId: orderListId,
          clientOrderId: clientOrderId,
          transactTime: transactTime,
        );

  @override
  List<Object> get props => [orderId];
}
