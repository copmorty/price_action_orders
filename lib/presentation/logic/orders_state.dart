part of 'orders_state_notifier.dart';

abstract class OrdersState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> openOrders;
  final List<Order> orderHistory;
  final List<Order> tradeHistory;

  OrdersLoaded({
    @required this.openOrders,
    this.orderHistory = const [],
    this.tradeHistory = const [],
  });

  @override
  List<Object> get props => [openOrders, orderHistory, tradeHistory];
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
