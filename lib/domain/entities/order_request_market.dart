import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order_request.dart';
import 'ticker.dart';

class MarketOrderRequest extends OrderRequest {
  /// Creates a market order request.
  ///
  /// The [quantity] or the [quoteOrderQty] must be provided,
  /// not both and not neither.
  MarketOrderRequest({
    @required Ticker ticker,
    @required BinanceOrderSide side,
    Decimal quantity,
    Decimal quoteOrderQty,
    int timestamp,
  })  : assert((quantity != null || quoteOrderQty != null) && !(quantity == null && quoteOrderQty == null)),
        super(
          ticker: ticker,
          side: side,
          type: BinanceOrderType.MARKET,
          quantity: quantity,
          quoteOrderQty: quoteOrderQty,
          timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        );
}
