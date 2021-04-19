import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';

class MarketOrderModel extends MarketOrder {
  MarketOrderModel({
    @required String symbol,
    @required BinanceOrderSide side,
    @required Decimal quantity,
    @required Decimal quoteOrderQty,
    int timestamp,
  })  : assert(quantity == null || quoteOrderQty == null),
        super(
          symbol: symbol,
          side: side,
          quantity: quantity,
          quoteOrderQty: quoteOrderQty,
          timestamp: timestamp,
        );

  @override
  List<Object> get props => [symbol, side, type, timestamp, quantity, quoteOrderQty];

  factory MarketOrderModel.fromMarketOrder(MarketOrder marketOrder) {
    return MarketOrderModel(
      symbol: marketOrder.symbol,
      side: marketOrder.side,
      quantity: marketOrder.quantity,
      quoteOrderQty: marketOrder.quoteOrderQty,
      timestamp: marketOrder.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'side': side.toShortString(),
      'type': type.toShortString(),
      'quantity': quantity.toString(),
      'quoteOrderQty': quoteOrderQty.toString(),
      'timestamp': timestamp.toString(),
    }..removeWhere((key, value) => value == null || value == 'null');
  }
}
