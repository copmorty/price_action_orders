part of 'bookticker_state_notifier.dart';

abstract class BookTickerState extends Equatable {
  const BookTickerState();

  @override
  List<Object> get props => [];
}

class BookTickerInitial extends BookTickerState {}

class BookTickerLoading extends BookTickerState {}

class BookTickerLoaded extends BookTickerState {
  final BookTicker bookTicker;

  BookTickerLoaded(this.bookTicker);

  @override
  List<Object> get props => [bookTicker];
}

class BookTickerError extends BookTickerState {
  final String message;

  BookTickerError(this.message);
  
  @override
  List<Object> get props => [message];
}
