part of 'orderconfig_bloc.dart';

abstract class OrderConfigState extends Equatable {
  const OrderConfigState();

  @override
  List<Object> get props => [];
}

class EmptyOrderConfig extends OrderConfigState {}

class LoadedOrderConfig extends OrderConfigState {
  final String baseAsset;
  final String quoteAsset;

  LoadedOrderConfig({
    @required this.baseAsset,
    @required this.quoteAsset,
  });

  @override
  List<Object> get props => [baseAsset, quoteAsset];
}
