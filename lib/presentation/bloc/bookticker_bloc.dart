import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/usecases/get_bookticker.dart';

part 'bookticker_event.dart';
part 'bookticker_state.dart';

class BookTickerBloc extends Bloc<BookTickerEvent, BookTickerState> {
  final GetBookTicker getBookTicker;
  StreamSubscription _subscription;

  BookTickerBloc({
    @required this.getBookTicker,
  }) : super(EmptyBookTicker());

  @override
  Stream<BookTickerState> mapEventToState(
    BookTickerEvent event,
  ) async* {
    if (event is GetBookTickerEvent) {
      yield LoadingBookTicker();
      await _subscription?.cancel();
      final failureOrStream = getBookTicker(Params(event.symbol));
      failureOrStream.fold(
        (failure) => ErrorBookTicker(message: 'idk'),
        (stream) {
          _subscription = stream.listen((event) => add(_BookTickerTick(event)));
        },
      );
    }
    if (event is _BookTickerTick) {
      yield LoadedBookTicker(bookTicker: event.tick);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
