import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'orderconfig_event.dart';
part 'orderconfig_state.dart';

class OrderConfigBloc extends Bloc<OrderConfigEvent, OrderConfigState> {
  OrderConfigBloc() : super(EmptyOrderConfig());

  @override
  Stream<OrderConfigState> mapEventToState(
    OrderConfigEvent event,
  ) async* {
    if (event is SetOrderConfigEvent) {
      yield LoadedOrderConfig(baseAsset: event.baseAsset, quoteAsset: event.quoteAsset);
    }
  }
}
