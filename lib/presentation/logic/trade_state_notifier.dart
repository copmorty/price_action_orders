import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_request.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/usecases/trade_post_order_uc.dart' as po;
import 'package:price_action_orders/domain/usecases/trade_cancel_order_uc.dart' as pco;

part 'trade_state.dart';

class TradeNotifier extends StateNotifier<TradeState> {
  final po.PostOrder _postOrder;
  final pco.CancelOrder _cancelOrder;

  TradeNotifier({
    required po.PostOrder postOrder,
    required pco.CancelOrder cancelOrder,
  })   : _postOrder = postOrder,
        _cancelOrder = cancelOrder,
        super(TradeInitial());

  Future<void> postOrder(OrderRequest order) async {
    state = TradeLoading(order.timestamp);

    final failureOrOrderResponse = await _postOrder(po.Params(order));
    failureOrOrderResponse.fold(
      (failure) => state = TradeError(orderTimestamp: order.timestamp, message: failure.message),
      (orderResponse) => state = TradeLoaded(orderResponse),
    );
  }

  Future<void> cancelOrder(CancelOrderRequest cancelOrderRequest) async {
    state = TradeLoading(cancelOrderRequest.timestamp);

    final failureOrCancelResponse = await _cancelOrder(pco.Params(cancelOrderRequest));
    failureOrCancelResponse.fold(
      (failure) => state = TradeError(orderTimestamp: cancelOrderRequest.timestamp, message: failure.message),
      (cancelResponse) => null, // The success case is managed by the user data stream (executionReport)
    );
  }
}
