import 'package:equatable/equatable.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';

class Trade extends Equatable {
  final String/*!*/ symbol;
  final int/*!*/ orderId;
  final Decimal/*!*/ price;
  final Decimal/*!*/ executedQty;
  final Decimal/*!*/ quoteQty;
  final BinanceOrderSide/*!*/ side;
  final int/*!*/ time;
  final int/*!*/ tradeId;
  final Decimal/*!*/ commisionAmount;
  final String/*!*/ commisionAsset;

  Trade({
    this.symbol,
    this.orderId,
    this.price,
    this.executedQty,
    this.quoteQty,
    this.side,
    this.time,
    this.tradeId,
    this.commisionAmount,
    this.commisionAsset,
  });

  @override
  List<Object> get props => [symbol, orderId, tradeId];
}
