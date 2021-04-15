import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order.dart';

class MarketOrder extends Order {
  final Decimal quantity;
  final Decimal quoteOrderQty;

  MarketOrder({
    @required symbol,
    @required side,
    @required timestamp,
    @required this.quantity,
    @required this.quoteOrderQty,
  })  : assert(quantity == null || quoteOrderQty == null),
        super(symbol: symbol, side: side, type: BinanceOrderType.MARKET, timestamp: timestamp);

  @override
  List<Object> get props => [symbol, side, type, timestamp, quantity, quoteOrderQty];
}
