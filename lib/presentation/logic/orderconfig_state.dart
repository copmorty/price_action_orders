part of 'orderconfig_state_notifier.dart';

abstract class OrderConfigState extends Equatable {
  const OrderConfigState();

  @override
  List<Object> get props => [];
}

class OrderConfigInitial extends OrderConfigState {}

class OrderConfigLoading extends OrderConfigState {}

class OrderConfigLoaded extends OrderConfigState {
  final Ticker ticker;

  OrderConfigLoaded(this.ticker);

  @override
  List<Object> get props => [ticker];
}
