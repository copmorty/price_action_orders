// Mocks generated by Mockito 5.0.15 from annotations
// in price_action_orders/test/presentation/logic/state_handler_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;

import 'package:flutter_riverpod/flutter_riverpod.dart' as _i9;
import 'package:mockito/mockito.dart' as _i1;
import 'package:price_action_orders/domain/entities/ticker.dart' as _i11;
import 'package:price_action_orders/presentation/logic/accountinfo_state_notifier.dart'
    as _i2;
import 'package:price_action_orders/presentation/logic/bookticker_state_notifier.dart'
    as _i4;
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart'
    as _i3;
import 'package:price_action_orders/presentation/logic/ticker_state_notifier.dart'
    as _i5;
import 'package:price_action_orders/presentation/logic/tickerstats_state_notifier.dart'
    as _i6;
import 'package:price_action_orders/presentation/logic/userdata_stream.dart'
    as _i7;
import 'package:state_notifier/state_notifier.dart' as _i10;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeAccountInfoState_0 extends _i1.Fake implements _i2.AccountInfoState {
}

class _FakeOrdersState_1 extends _i1.Fake implements _i3.OrdersState {}

class _FakeBookTickerState_2 extends _i1.Fake implements _i4.BookTickerState {}

class _FakeTickerState_3 extends _i1.Fake implements _i5.TickerState {}

class _FakeTickerStatsState_4 extends _i1.Fake implements _i6.TickerStatsState {
}

/// A class which mocks [UserDataStream].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserDataStream extends _i1.Mock implements _i7.UserDataStream {
  MockUserDataStream() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<void> initialization() =>
      (super.noSuchMethod(Invocation.method(#initialization, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Stream<dynamic> stream() =>
      (super.noSuchMethod(Invocation.method(#stream, []),
          returnValue: Stream<dynamic>.empty()) as _i8.Stream<dynamic>);
  @override
  String toString() => super.toString();
}

/// A class which mocks [AccountInfoNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockAccountInfoNotifier extends _i1.Mock
    implements _i2.AccountInfoNotifier {
  MockAccountInfoNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set onError(_i9.ErrorListener? _onError) =>
      super.noSuchMethod(Invocation.setter(#onError, _onError),
          returnValueForMissingStub: null);
  @override
  bool get mounted =>
      (super.noSuchMethod(Invocation.getter(#mounted), returnValue: false)
          as bool);
  @override
  _i8.Stream<_i2.AccountInfoState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i2.AccountInfoState>.empty())
          as _i8.Stream<_i2.AccountInfoState>);
  @override
  _i2.AccountInfoState get state =>
      (super.noSuchMethod(Invocation.getter(#state),
          returnValue: _FakeAccountInfoState_0()) as _i2.AccountInfoState);
  @override
  set state(_i2.AccountInfoState? value) =>
      super.noSuchMethod(Invocation.setter(#state, value),
          returnValueForMissingStub: null);
  @override
  _i2.AccountInfoState get debugState =>
      (super.noSuchMethod(Invocation.getter(#debugState),
          returnValue: _FakeAccountInfoState_0()) as _i2.AccountInfoState);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i8.Future<void> getAccountInfo() =>
      (super.noSuchMethod(Invocation.method(#getAccountInfo, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i9.RemoveListener addListener(_i10.Listener<_i2.AccountInfoState>? listener,
          {bool? fireImmediately = true}) =>
      (super.noSuchMethod(
          Invocation.method(
              #addListener, [listener], {#fireImmediately: fireImmediately}),
          returnValue: () {}) as _i9.RemoveListener);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}

/// A class which mocks [OrdersNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockOrdersNotifier extends _i1.Mock implements _i3.OrdersNotifier {
  MockOrdersNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set onError(_i9.ErrorListener? _onError) =>
      super.noSuchMethod(Invocation.setter(#onError, _onError),
          returnValueForMissingStub: null);
  @override
  bool get mounted =>
      (super.noSuchMethod(Invocation.getter(#mounted), returnValue: false)
          as bool);
  @override
  _i8.Stream<_i3.OrdersState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i3.OrdersState>.empty())
          as _i8.Stream<_i3.OrdersState>);
  @override
  _i3.OrdersState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeOrdersState_1()) as _i3.OrdersState);
  @override
  set state(_i3.OrdersState? value) =>
      super.noSuchMethod(Invocation.setter(#state, value),
          returnValueForMissingStub: null);
  @override
  _i3.OrdersState get debugState =>
      (super.noSuchMethod(Invocation.getter(#debugState),
          returnValue: _FakeOrdersState_1()) as _i3.OrdersState);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i8.Future<void> getOpenOrders() =>
      (super.noSuchMethod(Invocation.method(#getOpenOrders, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i9.RemoveListener addListener(_i10.Listener<_i3.OrdersState>? listener,
          {bool? fireImmediately = true}) =>
      (super.noSuchMethod(
          Invocation.method(
              #addListener, [listener], {#fireImmediately: fireImmediately}),
          returnValue: () {}) as _i9.RemoveListener);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}

/// A class which mocks [BookTickerNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockBookTickerNotifier extends _i1.Mock
    implements _i4.BookTickerNotifier {
  MockBookTickerNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set onError(_i9.ErrorListener? _onError) =>
      super.noSuchMethod(Invocation.setter(#onError, _onError),
          returnValueForMissingStub: null);
  @override
  bool get mounted =>
      (super.noSuchMethod(Invocation.getter(#mounted), returnValue: false)
          as bool);
  @override
  _i8.Stream<_i4.BookTickerState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i4.BookTickerState>.empty())
          as _i8.Stream<_i4.BookTickerState>);
  @override
  _i4.BookTickerState get state =>
      (super.noSuchMethod(Invocation.getter(#state),
          returnValue: _FakeBookTickerState_2()) as _i4.BookTickerState);
  @override
  set state(_i4.BookTickerState? value) =>
      super.noSuchMethod(Invocation.setter(#state, value),
          returnValueForMissingStub: null);
  @override
  _i4.BookTickerState get debugState =>
      (super.noSuchMethod(Invocation.getter(#debugState),
          returnValue: _FakeBookTickerState_2()) as _i4.BookTickerState);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i8.Future<void> initialization() =>
      (super.noSuchMethod(Invocation.method(#initialization, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> streamBookTicker(_i11.Ticker? ticker) =>
      (super.noSuchMethod(Invocation.method(#streamBookTicker, [ticker]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i9.RemoveListener addListener(_i10.Listener<_i4.BookTickerState>? listener,
          {bool? fireImmediately = true}) =>
      (super.noSuchMethod(
          Invocation.method(
              #addListener, [listener], {#fireImmediately: fireImmediately}),
          returnValue: () {}) as _i9.RemoveListener);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}

/// A class which mocks [TickerNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockTickerNotifier extends _i1.Mock implements _i5.TickerNotifier {
  MockTickerNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set onError(_i9.ErrorListener? _onError) =>
      super.noSuchMethod(Invocation.setter(#onError, _onError),
          returnValueForMissingStub: null);
  @override
  bool get mounted =>
      (super.noSuchMethod(Invocation.getter(#mounted), returnValue: false)
          as bool);
  @override
  _i8.Stream<_i5.TickerState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i5.TickerState>.empty())
          as _i8.Stream<_i5.TickerState>);
  @override
  _i5.TickerState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeTickerState_3()) as _i5.TickerState);
  @override
  set state(_i5.TickerState? value) =>
      super.noSuchMethod(Invocation.setter(#state, value),
          returnValueForMissingStub: null);
  @override
  _i5.TickerState get debugState =>
      (super.noSuchMethod(Invocation.getter(#debugState),
          returnValue: _FakeTickerState_3()) as _i5.TickerState);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i8.Future<void> initialization() =>
      (super.noSuchMethod(Invocation.method(#initialization, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<bool> setTicker(_i11.Ticker? ticker, {bool? init = false}) =>
      (super.noSuchMethod(
          Invocation.method(#setTicker, [ticker], {#init: init}),
          returnValue: Future<bool>.value(false)) as _i8.Future<bool>);
  @override
  _i9.RemoveListener addListener(_i10.Listener<_i5.TickerState>? listener,
          {bool? fireImmediately = true}) =>
      (super.noSuchMethod(
          Invocation.method(
              #addListener, [listener], {#fireImmediately: fireImmediately}),
          returnValue: () {}) as _i9.RemoveListener);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}

/// A class which mocks [TickerStatsNotifier].
///
/// See the documentation for Mockito's code generation for more information.
class MockTickerStatsNotifier extends _i1.Mock
    implements _i6.TickerStatsNotifier {
  MockTickerStatsNotifier() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set onError(_i9.ErrorListener? _onError) =>
      super.noSuchMethod(Invocation.setter(#onError, _onError),
          returnValueForMissingStub: null);
  @override
  bool get mounted =>
      (super.noSuchMethod(Invocation.getter(#mounted), returnValue: false)
          as bool);
  @override
  _i8.Stream<_i6.TickerStatsState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i6.TickerStatsState>.empty())
          as _i8.Stream<_i6.TickerStatsState>);
  @override
  _i6.TickerStatsState get state =>
      (super.noSuchMethod(Invocation.getter(#state),
          returnValue: _FakeTickerStatsState_4()) as _i6.TickerStatsState);
  @override
  set state(_i6.TickerStatsState? value) =>
      super.noSuchMethod(Invocation.setter(#state, value),
          returnValueForMissingStub: null);
  @override
  _i6.TickerStatsState get debugState =>
      (super.noSuchMethod(Invocation.getter(#debugState),
          returnValue: _FakeTickerStatsState_4()) as _i6.TickerStatsState);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i8.Future<void> initialization() =>
      (super.noSuchMethod(Invocation.method(#initialization, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> streamTickerStats(_i11.Ticker? ticker) =>
      (super.noSuchMethod(Invocation.method(#streamTickerStats, [ticker]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i9.RemoveListener addListener(_i10.Listener<_i6.TickerStatsState>? listener,
          {bool? fireImmediately = true}) =>
      (super.noSuchMethod(
          Invocation.method(
              #addListener, [listener], {#fireImmediately: fireImmediately}),
          returnValue: () {}) as _i9.RemoveListener);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}
