part of 'orders_state_notifier.dart';

abstract class OrdersState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class Ordersloading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final openOrders;

  OrdersLoaded(this.openOrders);

  @override
  List<Object> get props => [];
}

class OrdersError extends OrdersState {
    final String message;

  OrdersError(this.message);

  @override
  List<Object> get props => [message];
}