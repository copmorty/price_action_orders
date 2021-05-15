part of 'orderrequest_state_notifier.dart';

abstract class OrderRequestState extends Equatable {
  const OrderRequestState();

  @override
  List<Object> get props => [];
}

class OrderRequestInitial extends OrderRequestState {}

class MarketOrderLoaded extends OrderRequestState {
  final OrderResponseFull orderResponse;

  MarketOrderLoaded(this.orderResponse);

  @override
  List<Object> get props => [orderResponse];
}

class LimitOrderLoaded extends OrderRequestState {
  final OrderResponseFull orderResponse;

  LimitOrderLoaded(this.orderResponse);

  @override
  List<Object> get props => [orderResponse];
}

class OrderRequestError extends OrderRequestState {
  final int orderTimestamp;
  final String message;

  OrderRequestError({@required this.orderTimestamp, @required this.message});

  @override
  List<Object> get props => [orderTimestamp, message];
}
