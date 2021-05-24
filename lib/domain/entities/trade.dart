import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';

class Trade extends Equatable {
  final String symbol;
  final int orderId;
  final Decimal price;
  final Decimal executedQty;
  final Decimal quoteQty;
  final BinanceOrderSide side;
  final int time;
  final int tradeId;
  final Decimal commisionAmount;
  final String commisionAsset;

  Trade({
    @required this.symbol,
    @required this.orderId,
    @required this.price,
    @required this.executedQty,
    @required this.quoteQty,
    @required this.side,
    @required this.time,
    @required this.tradeId,
    @required this.commisionAmount,
    @required this.commisionAsset,
  });

  @override
  List<Object> get props => [tradeId];
}
