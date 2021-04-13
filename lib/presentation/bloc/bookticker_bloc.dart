import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/usecases/stream_bookticker.dart';

part 'bookticker_event.dart';
part 'bookticker_state.dart';

class BookTickerBloc extends Bloc<BookTickerEvent, BookTickerState> {
  final StreamBookTicker streamBookTicker;
  StreamSubscription _subscription;

  BookTickerBloc({
    @required this.streamBookTicker,
  }) : super(EmptyBookTicker());

  @override
  Stream<BookTickerState> mapEventToState(
    BookTickerEvent event,
  ) async* {
    if (event is StreamBookTickerEvent) {
      yield LoadingBookTicker();
      await _subscription?.cancel();
      final failureOrStream = streamBookTicker(Params(baseAsset: event.baseAsset, quoteAsset: event.quoteAsset));
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
