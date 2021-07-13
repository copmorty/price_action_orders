import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

part 'orderconfig_state.dart';

class OrderConfigNotifier extends StateNotifier<OrderConfigState> {
  OrderConfigNotifier() : super(OrderConfigInitial());

  void setLoading() {
    state = OrderConfigLoading();
  }

  void setLoaded(Ticker ticker) {
    state = OrderConfigLoaded(ticker);
  }
}
