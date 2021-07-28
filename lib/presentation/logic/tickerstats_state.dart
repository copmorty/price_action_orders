part of 'tickerstats_state_notifier.dart';

abstract class TickerStatsState extends Equatable {
  const TickerStatsState();

  @override
  List<Object> get props => [];
}

class TickerStatsInitial extends TickerStatsState {}

class TickerStatsLoading extends TickerStatsState {}

class TickerStatsLoaded extends TickerStatsState {
  final TickerStats tickerStats;

  TickerStatsLoaded(this.tickerStats);

  @override
  List<Object> get props => [tickerStats];
}

class TickerStatsError extends TickerStatsState {
  final String message;

  TickerStatsError(this.message);

  @override
  List<Object> get props => [message];
}
