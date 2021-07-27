import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'order_request.dart';
import 'ticker.dart';

class StopLimitOrderRequest extends OrderRequest {
  StopLimitOrderRequest({
    required Ticker ticker,
    required BinanceOrderSide side,
    required BinanceOrderTimeInForce timeInForce,
    BinanceOrderType? type,
    Decimal? currentMarketPrice,
    required Decimal quantity,
    required Decimal price,
    required Decimal stopPrice,
    int? timestamp,
  })  : assert((type != null || currentMarketPrice != null) && !(type == null && currentMarketPrice == null)),
        assert((type == null || (type == BinanceOrderType.TAKE_PROFIT_LIMIT || type == BinanceOrderType.STOP_LOSS_LIMIT))),
        super(
          ticker: ticker,
          side: side,
          type: type ??
              (side == BinanceOrderSide.BUY
                  ? (stopPrice >= currentMarketPrice! ? BinanceOrderType.STOP_LOSS_LIMIT : BinanceOrderType.TAKE_PROFIT_LIMIT)
                  : (stopPrice <= currentMarketPrice! ? BinanceOrderType.STOP_LOSS_LIMIT : BinanceOrderType.TAKE_PROFIT_LIMIT)),
          timeInForce: timeInForce,
          quantity: quantity,
          price: price,
          stopPrice: stopPrice,
          newOrderRespType: BinanceNewOrderResponseType.FULL,
          timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
        );
}
