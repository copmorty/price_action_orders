import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class MarketOrderRequestModel extends MarketOrderRequest {
  MarketOrderRequestModel({
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
          quantity: quantity,
          quoteOrderQty: quoteOrderQty,
          timestamp: timestamp,
        );

  @override
  List<Object> get props => [symbol, side, type, timestamp, quantity, quoteOrderQty];

  factory MarketOrderRequestModel.fromMarketOrderRequest(MarketOrderRequest marketOrder) {
    return MarketOrderRequestModel(
      ticker: marketOrder.ticker,
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
