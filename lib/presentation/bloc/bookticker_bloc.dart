import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/usecases/get_lastticker.dart';
import 'package:price_action_orders/domain/usecases/stream_bookticker.dart';
import 'package:price_action_orders/presentation/bloc/orderconfig_bloc.dart';

part 'bookticker_event.dart';
part 'bookticker_state.dart';

class BookTickerBloc extends Bloc<BookTickerEvent, BookTickerState> {
  final GetLastTicker getLastTicker;
  final StreamBookTicker streamBookTicker;
  final OrderConfigBloc orderConfigBloc;
  StreamSubscription _subscription;

  BookTickerBloc({
    @required this.getLastTicker,
    @required this.streamBookTicker,
    @required this.orderConfigBloc,
  }) : super(EmptyBookTicker());

  @override
  Stream<BookTickerState> mapEventToState(
    BookTickerEvent event,
  ) async* {
    if (event is StartBookTickerEvent) {
      final failureOrTicker = await getLastTicker(NoParams());
      failureOrTicker.fold(
        (failure) => print('No ticker cached yet'),
        (ticker) => add(StreamBookTickerEvent(ticker)),
      );
    }

    if (event is StreamBookTickerEvent) {
      yield LoadingBookTicker();
      await _subscription?.cancel();
      final failureOrStream = await streamBookTicker(Params(event.ticker));
      failureOrStream.fold(
        (failure) => ErrorBookTicker(message: 'idk'),
        (stream) {
          orderConfigBloc.add(SetOrderConfigEvent(event.ticker));
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
