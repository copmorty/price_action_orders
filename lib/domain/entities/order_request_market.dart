import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order_request.dart';
import 'ticker.dart';

class MarketOrderRequest extends OrderRequest {
  MarketOrderRequest({
    @required Ticker ticker,
    @required BinanceOrderSide side,
    @required Decimal quantity,
    @required Decimal quoteOrderQty,
    int timestamp,
  })  : assert(quantity == null || quoteOrderQty == null),
        super(
          ticker: ticker,
          side: side,
          type: BinanceOrderType.MARKET,
          quantity: quantity,
          quoteOrderQty: quoteOrderQty,
          timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        );
}
