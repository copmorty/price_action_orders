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
  }) : super(Empty());

  @override
  Stream<BookTickerState> mapEventToState(
    BookTickerEvent event,
  ) async* {
    if (event is GetBookTickerEvent) {
      await _subscription?.cancel();
      _subscription = getBookTicker().listen((event) {
        return add(_BookTickerTick(event));
      });
    }
    if (event is _BookTickerTick) {
      yield Loaded(bookTicker: event.tick);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
