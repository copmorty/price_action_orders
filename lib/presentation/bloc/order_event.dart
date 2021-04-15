part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class MarketOrderEvent extends OrderEvent {
  final MarketOrder marketOrder;

  MarketOrderEvent(this.marketOrder);

  @override
  List<Object> get props => [marketOrder];
}
