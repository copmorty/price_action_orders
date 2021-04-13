part of 'bookticker_bloc.dart';

abstract class BookTickerEvent extends Equatable {
  const BookTickerEvent();

  @override
  List<Object> get props => [];
}

class StreamBookTickerEvent extends BookTickerEvent {
  final String baseAsset;
  final String quoteAsset;

  StreamBookTickerEvent({@required this.baseAsset, @required this.quoteAsset});

  @override
  List<Object> get props => [baseAsset, quoteAsset];
}

class _BookTickerTick extends BookTickerEvent {
  final BookTicker tick;

  _BookTickerTick(this.tick);

  @override
  List<Object> get props => [tick];
}
