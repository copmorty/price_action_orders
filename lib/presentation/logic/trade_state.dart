part of 'trade_state_notifier.dart';

abstract class TradeState extends Equatable {
  const TradeState();

  @override
  List<Object> get props => [];
}

class TradeInitial extends TradeState {}

class MarketTradeLoaded extends TradeState {
  final OrderResponseFull orderResponse;

  MarketTradeLoaded(this.orderResponse);

  @override
  List<Object> get props => [orderResponse];
}

class LimitTradeLoaded extends TradeState {
  final OrderResponseFull orderResponse;

  LimitTradeLoaded(this.orderResponse);

  @override
  List<Object> get props => [orderResponse];
}

class TradeError extends TradeState {
  final int orderTimestamp;
  final String message;

  TradeError({@required this.orderTimestamp, @required this.message});

  @override
  List<Object> get props => [orderTimestamp, message];
}
