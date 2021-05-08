import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/domain/entities/order_limit.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/usecases/post_limitorder.dart' as plo;
import 'package:price_action_orders/domain/usecases/post_marketorder.dart' as pmo;

part 'order_state.dart';

class OrderNotifier extends StateNotifier<OrderState> {
  final plo.PostLimitOrder _postLimitOrder;
  final pmo.PostMarketOrder _postMarketOrder;

  OrderNotifier({
    @required postLimitOrder,
    @required postMarketOrder,
  })  : _postLimitOrder = postLimitOrder,
        _postMarketOrder = postMarketOrder,
        super(OrderInitial());

  Future<void> postMarketOrder(MarketOrder marketOrder) async {
    final failureOrOrderResponse = await _postMarketOrder(pmo.Params(marketOrder));
    failureOrOrderResponse.fold(
      (failure) => state = OrderError(orderTimestamp: marketOrder.timestamp, message: failure.message),
      (orderResponse) => state = MarketOrderLoaded(orderResponse),
    );
  }

  Future<void> postLimitOrder(LimitOrder limitOrder) async {
    final failureOrOrderResponse = await _postLimitOrder(plo.Params(limitOrder));
    failureOrOrderResponse.fold(
      (failure) => OrderError(orderTimestamp: limitOrder.timestamp, message: failure.message),
      (orderResponse) => LimitOrderLoaded(orderResponse),
    );
  }
}
