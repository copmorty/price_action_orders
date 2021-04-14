part of 'orderconfig_bloc.dart';

abstract class OrderConfigEvent extends Equatable {
  const OrderConfigEvent();

  @override
  List<Object> get props => [];
}

class SetOrderConfigEvent extends OrderConfigEvent {
  final String baseAsset;
  final String quoteAsset;

  SetOrderConfigEvent({
    this.baseAsset,
    this.quoteAsset,
  });

  @override
  List<Object> get props => [baseAsset, quoteAsset];
}
