import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:meta/meta.dart';

class Order extends Equatable {
  final String symbol;
  final BinanceOrderSide side;
  final BinanceOrderType type;
  final BinanceOrderTimeInForce timeInForce;
  final Decimal quantity;
  final Decimal quoteOrderQty;
  final Decimal price;
  final String newClientOrderId;
  final Decimal stopPrice;
  final Decimal icebergQty;
  final BinanceOrderResponseType newOrderRespType;
  final int recvWindow;
  final int timestamp;

  Order({
    @required this.symbol,
    @required this.side,
    @required this.type,
    this.timeInForce,
    this.quantity,
    this.quoteOrderQty,
    this.price,
    this.newClientOrderId,
    this.stopPrice,
    this.icebergQty,
    this.newOrderRespType,
    this.recvWindow,
    @required this.timestamp,
  });

  @override
  List<Object> get props => [symbol, side, type, timestamp];
}
