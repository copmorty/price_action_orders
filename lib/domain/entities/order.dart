import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/globals/enums.dart';

class Order extends Equatable {
  final String symbol;
  final int orderId;
  final int orderListId;
  final String clientOrderId;
  final Decimal price;
  final Decimal origQty;
  final Decimal executedQty;
  final Decimal cummulativeQuoteQty;
  final BinanceOrderStatus status;
  final BinanceOrderTimeInForce timeInForce;
  final BinanceOrderType type;
  final BinanceOrderSide side;
  final Decimal stopPrice;
  final Decimal icebergQty;
  final int time;
  final int updateTime;
  final bool isWorking;
  final Decimal origQuoteOrderQty;

  Order({
    @required this.symbol,
    @required this.orderId,
    @required this.orderListId,
    @required this.clientOrderId,
    @required this.price,
    @required this.origQty,
    @required this.executedQty,
    @required this.cummulativeQuoteQty,
    @required this.status,
    @required this.timeInForce,
    @required this.type,
    @required this.side,
    @required this.stopPrice,
    @required this.icebergQty,
    @required this.time,
    @required this.updateTime,
    @required this.isWorking,
    @required this.origQuoteOrderQty,
  });

  @override
  List<Object> get props => [symbol, orderId, updateTime];
}
