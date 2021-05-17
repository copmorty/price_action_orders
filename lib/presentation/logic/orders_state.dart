part of 'orders_state_notifier.dart';

abstract class OrdersState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class Ordersloading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Order> openOrders;

  OrdersLoaded(this.openOrders);

  @override
  List<Object> get props => [openOrders];
}

class OrdersError extends OrdersState {
    final String message;

  OrdersError(this.message);

  @override
  List<Object> get props => [message];
}