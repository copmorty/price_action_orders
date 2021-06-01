import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/usecases/post_trade_limit_order.dart' as plo;
import 'package:price_action_orders/domain/usecases/post_trade_market_order.dart' as pmo;
import 'package:price_action_orders/domain/usecases/post_trade_cancel_order.dart' as pco;

part 'trade_state.dart';

class TradeNotifier extends StateNotifier<TradeState> {
  final plo.PostLimitOrder _postLimitOrder;
  final pmo.PostMarketOrder _postMarketOrder;
  final pco.PostCancelOrder _postCancelOrder;

  TradeNotifier({
    @required plo.PostLimitOrder postLimitOrder,
    @required pmo.PostMarketOrder postMarketOrder,
    @required pco.PostCancelOrder postCancelOrder,
  })  : _postLimitOrder = postLimitOrder,
        _postMarketOrder = postMarketOrder,
        _postCancelOrder = postCancelOrder,
        super(TradeInitial());

  Future<void> postLimitOrder(LimitOrderRequest limitOrder) async {
    state = TradeLoading(limitOrder.timestamp);

    final failureOrOrderResponse = await _postLimitOrder(plo.Params(limitOrder));
    failureOrOrderResponse.fold(
      (failure) => state = TradeError(orderTimestamp: limitOrder.timestamp, message: failure.message),
      (orderResponse) => state = TradeLoaded(orderResponse),
    );
  }

  Future<void> postMarketOrder(MarketOrderRequest marketOrder) async {
    state = TradeLoading(marketOrder.timestamp);

    final failureOrOrderResponse = await _postMarketOrder(pmo.Params(marketOrder));
    failureOrOrderResponse.fold(
      (failure) => state = TradeError(orderTimestamp: marketOrder.timestamp, message: failure.message),
      (orderResponse) => state = TradeLoaded(orderResponse),
    );
  }

  Future<void> postCancelOrder(CancelOrderRequest cancelOrderRequest) async {
    state = TradeLoading(cancelOrderRequest.timestamp);

    final failureOrCancelResponse = await _postCancelOrder(pco.Params(cancelOrderRequest));
    failureOrCancelResponse.fold(
      (failure) => state = TradeError(orderTimestamp: cancelOrderRequest.timestamp, message: failure.message),
      (cancelResponse) => null, // The success case is managed by the user data stream (executionReport)
    );
  }
}
