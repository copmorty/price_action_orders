part of 'bookticker_bloc.dart';

abstract class BookTickerEvent extends Equatable {
  const BookTickerEvent();

  @override
  List<Object> get props => [];
}

class StartBookTickerEvent extends BookTickerEvent {}

class StreamBookTickerEvent extends BookTickerEvent {
  final Ticker ticker;

  StreamBookTickerEvent(this.ticker);

  @override
  List<Object> get props => [ticker];
}

class _BookTickerTick extends BookTickerEvent {
  final BookTicker tick;

  _BookTickerTick(this.tick);

  @override
  List<Object> get props => [tick];
}
