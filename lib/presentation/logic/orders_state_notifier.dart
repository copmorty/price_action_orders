import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order.dart';
import 'package:price_action_orders/domain/usecases/get_userdata_openorders.dart';

part 'orders_state.dart';

class OrdersNotifier extends StateNotifier<OrdersState> {
  final GetOpenOrders _getOpenOrders;

  OrdersNotifier({
    @required GetOpenOrders getOpenOrders,
    bool start = true,
  })  : _getOpenOrders = getOpenOrders,
        super(OrdersInitial()) {
    if (start) this.getOpenOrders();
  }

  Future<void> getOpenOrders() async {
    state = Ordersloading();

    final response = await _getOpenOrders(NoParams());
    response.fold(
      (failure) => state = OrdersError('failure.message'),
      (openOrders) => state = OrdersLoaded(openOrders),
    );
  }
}
