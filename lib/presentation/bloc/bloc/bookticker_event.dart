part of 'bookticker_bloc.dart';

abstract class BookTickerEvent extends Equatable {
  const BookTickerEvent();

  @override
  List<Object> get props => [];
}

class GetBookTickerEvent extends BookTickerEvent {
  final String symbol;

  GetBookTickerEvent(this.symbol);

  @override
  List<Object> get props => [symbol];
}

class _BookTickerTick extends BookTickerEvent {
  final BookTicker tick;

  _BookTickerTick(this.tick);

  @override
  List<Object> get props => [tick];
}
