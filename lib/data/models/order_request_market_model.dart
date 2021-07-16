import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class MarketOrderRequestModel extends MarketOrderRequest {
  /// Creates a market order request model.
  ///
  /// The [quantity] or the [quoteOrderQty] must be provided,
  /// not both and not neither.
  MarketOrderRequestModel({
    Ticker/*!*/ ticker,
    BinanceOrderSide/*!*/ side,
    Decimal quantity,
    Decimal quoteOrderQty,
    int timestamp,
  })  : assert((quantity != null || quoteOrderQty != null) && !(quantity == null && quoteOrderQty == null)),
        super(
          ticker: ticker,
          side: side,
          quantity: quantity,
          quoteOrderQty: quoteOrderQty,
          timestamp: timestamp,
        );

  factory MarketOrderRequestModel.fromMarketOrderRequest(MarketOrderRequest marketOrderRequest) {
    return MarketOrderRequestModel(
      ticker: marketOrderRequest.ticker,
      side: marketOrderRequest.side,
      quantity: marketOrderRequest.quantity,
      quoteOrderQty: marketOrderRequest.quoteOrderQty,
      timestamp: marketOrderRequest.timestamp,
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
