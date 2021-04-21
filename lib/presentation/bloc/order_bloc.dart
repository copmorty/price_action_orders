import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/domain/entities/order_limit.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/usecases/post_limitorder.dart' as plo;
import 'package:price_action_orders/domain/usecases/post_marketorder.dart' as pmo;
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final pmo.PostMarketOrder postMarketOrder;
  final plo.PostLimitOrder postLimitOrder;

  OrderBloc({@required this.postLimitOrder, @required this.postMarketOrder}) : super(EmptyOrder());

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is MarketOrderEvent) {
      final failureOrOrderResponse = await postMarketOrder(pmo.Params(marketOrder: event.marketOrder));
      yield failureOrOrderResponse.fold(
        (failure) => ErrorOrder(orderTimestamp: event.marketOrder.timestamp, message: failure.message),
        (orderResponse) => LoadedMarketOrder(orderResponse),
      );
    }
    if (event is LimitOrderEvent) {
      final failureOrOrderResponse = await postLimitOrder(plo.Params(event.limitOrder));
      yield failureOrOrderResponse.fold(
        (failure) => ErrorOrder(orderTimestamp: event.limitOrder.timestamp, message: failure.message),
        (orderResponse) => LoadedLimitOrder(orderResponse),
      );
    }
  }
}
