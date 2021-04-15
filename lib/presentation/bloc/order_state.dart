part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class EmptyOrder extends OrderState {}

class LoadedMarketOrder extends OrderState {
  final orderId = Random().nextInt(10000);

  @override
  List<Object> get props => [orderId];
}
