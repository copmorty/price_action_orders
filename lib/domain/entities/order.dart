import 'package:equatable/equatable.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';

class Order extends Equatable {
  final String/*!*/ symbol;
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
  final Decimal/*!*/ stopPrice;
  final Decimal/*!*/ icebergQty;
  final int/*!*/ time;
  final int/*!*/ updateTime;
  final bool/*!*/ isWorking;
  final Decimal/*!*/ origQuoteOrderQty;

  Order({
    this.symbol,
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
    this.stopPrice,
    this.icebergQty,
    this.time,
    this.updateTime,
    this.isWorking,
    this.origQuoteOrderQty,
  });

  @override
  List<Object> get props => [symbol, orderId, updateTime];
}
