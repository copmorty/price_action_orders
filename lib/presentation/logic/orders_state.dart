part of 'orders_state_notifier.dart';

abstract class OrdersState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> _openOrders;
  final List<Order> _orderHistory;
  final List<Trade> _tradeHistory;

  OrdersLoaded({
    List<Order>/*!*/ openOrders,
    List<Order> orderHistory = const [],
    List<Trade> tradeHistory = const [],
  })  : _openOrders = openOrders,
        _orderHistory = orderHistory,
        _tradeHistory = tradeHistory;

  // In this way the lists are immutable
  get openOrders => List.of(_openOrders);
  get orderHistory => List.of(_orderHistory);
  get tradeHistory => List.of(_tradeHistory);

  @override
  List<Object> get props => [_openOrders, _orderHistory, _tradeHistory];
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
