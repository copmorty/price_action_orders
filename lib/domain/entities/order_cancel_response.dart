import 'package:equatable/equatable.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';

class CancelOrderResponse extends Equatable {
  final String/*!*/ symbol;
  final String/*!*/ origClientOrderId;
  final int/*!*/ orderId;
  final int/*!*/ orderListId;
  final String/*!*/ clientOrderId;
  final Decimal/*!*/ price;
  final Decimal/*!*/ origQty;
  final Decimal/*!*/ executedQty;
  final Decimal/*!*/ cummulativeQuoteQty;
  final BinanceOrderStatus/*!*/ status;
  final BinanceOrderTimeInForce/*!*/ timeInForce;
  final BinanceOrderType/*!*/ type;
  final BinanceOrderSide/*!*/ side;

  CancelOrderResponse({
    this.symbol,
    this.origClientOrderId,
    this.orderId,
    this.orderListId,
    this.clientOrderId,
    this.price,
    this.origQty,
    this.executedQty,
    this.cummulativeQuoteQty,
    this.status,
    this.timeInForce,
    this.type,
    this.side,
  });

  @override
  List<Object> get props => [symbol, orderId];
}
