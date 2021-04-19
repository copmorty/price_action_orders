part of 'orderconfig_bloc.dart';

abstract class OrderConfigEvent extends Equatable {
  const OrderConfigEvent();

  @override
  List<Object> get props => [];
}

class SetOrderConfigEvent extends OrderConfigEvent {
  final Ticker ticker;

  SetOrderConfigEvent(this.ticker);

  @override
  List<Object> get props => [ticker];
}
