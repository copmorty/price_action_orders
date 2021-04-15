part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class EmptyOrder extends OrderState {}

class LoadedMarketOrder extends OrderState {
  final OrderResponseFull orderResponse;

  LoadedMarketOrder(this.orderResponse);

  @override
  List<Object> get props => [orderResponse];
}

class ErrorOrder extends OrderState {
  final String message;

  ErrorOrder({@required this.message});

  @override
  List<Object> get props => [message];
}
