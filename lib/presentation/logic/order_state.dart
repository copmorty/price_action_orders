part of 'order_state_notifier.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class MarketOrderLoaded extends OrderState {
  final OrderResponseFull orderResponse;

  MarketOrderLoaded(this.orderResponse);

  @override
  List<Object> get props => [orderResponse];
}

class LimitOrderLoaded extends OrderState {
  final OrderResponseFull orderResponse;

  LimitOrderLoaded(this.orderResponse);

  @override
  List<Object> get props => [orderResponse];
}

class OrderError extends OrderState {
  final int orderTimestamp;
  final String message;

  OrderError({@required this.orderTimestamp, @required this.message});

  @override
  List<Object> get props => [orderTimestamp, message];
}
