import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/usecases/post_marketorder.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final PostMarketOrder postMarketOrder;

  OrderBloc({@required this.postMarketOrder}) : super(EmptyOrder());

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is MarketOrderEvent) {
      final failureOrOrderResponse = await postMarketOrder(Params(marketOrder: event.marketOrder));
      yield failureOrOrderResponse.fold(
        (failure) => ErrorOrder(orderTimestamp: event.marketOrder.timestamp, message: failure.message),
        (orderResponse) => LoadedMarketOrder(orderResponse),
      );
    }
  }
}
