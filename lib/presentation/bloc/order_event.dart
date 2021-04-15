part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class MarketOrderEvent extends OrderEvent {
  final String baseAsset;
  final String quoteAsset;
  final BinanceOrderSide side;
  final Decimal quantity;
  final Decimal quoteOrderQty;

  MarketOrderEvent(this.baseAsset, this.quoteAsset, this.side, this.quantity, this.quoteOrderQty);

  @override
  List<Object> get props => [baseAsset, quoteAsset, side, quantity, quoteOrderQty];
}
