import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'order.dart';

class MarketOrder extends Order {
  MarketOrder({
    @required Ticker ticker,
    // @required String symbol,
    @required BinanceOrderSide side,
    @required Decimal quantity,
    @required Decimal quoteOrderQty,
    int timestamp,
  })  : assert(quantity == null || quoteOrderQty == null),
        super(
          ticker: ticker,
          // symbol: symbol,
          side: side,
          type: BinanceOrderType.MARKET,
          quantity: quantity,
          quoteOrderQty: quoteOrderQty,
          timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        );

  @override
  List<Object> get props => [symbol, side, type, timestamp, quantity, quoteOrderQty];
}
