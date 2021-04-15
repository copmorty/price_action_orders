import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/globals/enums.dart';
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
      await postMarketOrder(Params(
        baseAsset: event.baseAsset,
        quoteAsset: event.quoteAsset,
        side: event.side,
        quantity: event.quantity,
        quoteOrderQty: event.quoteOrderQty,
      ));
      yield LoadedMarketOrder();
    }
  }
}
