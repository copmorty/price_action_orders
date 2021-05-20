import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/usecases/post_limitorder.dart' as plo;
import 'package:price_action_orders/domain/usecases/post_marketorder.dart' as pmo;
import 'package:price_action_orders/domain/usecases/post_cancelorder.dart' as pco;

part 'orderrequest_state.dart';

class OrderRequestNotifier extends StateNotifier<OrderRequestState> {
  final plo.PostLimitOrder _postLimitOrder;
  final pmo.PostMarketOrder _postMarketOrder;
  final pco.PostCancelOrder _postCancelOrder;

  OrderRequestNotifier({
    @required plo.PostLimitOrder postLimitOrder,
    @required pmo.PostMarketOrder postMarketOrder,
    @required pco.PostCancelOrder postCancelOrder,
  })  : _postLimitOrder = postLimitOrder,
        _postMarketOrder = postMarketOrder,
        _postCancelOrder = postCancelOrder,
        super(OrderRequestInitial());

  Future<void> postLimitOrder(LimitOrderRequest limitOrder) async {
    final failureOrOrderResponse = await _postLimitOrder(plo.Params(limitOrder));
    failureOrOrderResponse.fold(
      (failure) => state = OrderRequestError(orderTimestamp: limitOrder.timestamp, message: failure.message),
      (orderResponse) => state = LimitOrderLoaded(orderResponse),
    );
  }

  Future<void> postMarketOrder(MarketOrderRequest marketOrder) async {
    final failureOrOrderResponse = await _postMarketOrder(pmo.Params(marketOrder));
    failureOrOrderResponse.fold(
      (failure) => state = OrderRequestError(orderTimestamp: marketOrder.timestamp, message: failure.message),
      (orderResponse) => state = MarketOrderLoaded(orderResponse),
    );
  }

  Future<void> postCancelOrder(CancelOrderRequest cancelOrderRequest) async {
    print('logic postCancelOrder');
    final failureOrCancelResponse = await _postCancelOrder(pco.Params(cancelOrderRequest));
    failureOrCancelResponse.fold(
      (l) => null, //NEEDS LATER IMPLEMENTATION
      (r) => null, //The success case is managed by the stream (executionReport)
    );
  }
}