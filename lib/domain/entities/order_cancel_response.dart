import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/globals/enums.dart';

class CancelOrderResponse extends Equatable {
  final String symbol;
  final String origClientOrderId;
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

  CancelOrderResponse({
    required this.symbol,
    required this.origClientOrderId,
    required this.orderId,
    required this.orderListId,
    required this.clientOrderId,
    required this.price,
    required this.origQty,
    required this.executedQty,
    required this.cummulativeQuoteQty,
    required this.status,
    required this.timeInForce,
    required this.type,
    required this.side,
  });

  @override
  List<Object> get props => [symbol, orderId];
}
