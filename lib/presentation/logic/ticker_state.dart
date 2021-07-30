part of 'ticker_state_notifier.dart';

abstract class TickerState extends Equatable {
  const TickerState();

  @override
  List<Object> get props => [];
}

class TickerInitial extends TickerState {}

class TickerLoading extends TickerState {}

class TickerLoaded extends TickerState {
  final Ticker ticker;

  TickerLoaded(this.ticker);

  @override
  List<Object> get props => [ticker];
}
