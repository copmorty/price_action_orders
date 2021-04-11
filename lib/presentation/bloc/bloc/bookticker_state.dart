part of 'bookticker_bloc.dart';

abstract class BookTickerState extends Equatable {
  const BookTickerState();

  @override
  List<Object> get props => [];
}

class Empty extends BookTickerState {}

class Loading extends BookTickerState {}

class Loaded extends BookTickerState {
  final BookTicker bookTicker;

  Loaded({@required this.bookTicker});

  @override
  List<Object> get props => [bookTicker];
}

class Error extends BookTickerState {
  final String message;

  Error({@required this.message});
  
  @override
  List<Object> get props => [message];
}
