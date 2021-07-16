part of 'trade_state_notifier.dart';

abstract class TradeState extends Equatable {
  const TradeState();

  @override
  List<Object> get props => [];
}

class TradeInitial extends TradeState {}

class TradeLoading extends TradeState {
  final int operationId;

  TradeLoading(this.operationId);

  @override
  List<Object> get props => [operationId];
}

class TradeLoaded extends TradeState {
  final OrderResponseFull orderResponse;

  TradeLoaded(this.orderResponse);

  @override
  List<Object> get props => [orderResponse];
}

class TradeError extends TradeState {
  final int/*!*/ orderTimestamp;
  final String/*!*/ message;

  TradeError({
    this.orderTimestamp,
    this.message,
  });

  @override
  List<Object> get props => [orderTimestamp, message];
}
