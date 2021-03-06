// Mocks generated by Mockito 5.0.15 from annotations
// in price_action_orders/test/domain/usecases/user_set_last_ticker_uc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:price_action_orders/core/error/failures.dart' as _i5;
import 'package:price_action_orders/core/globals/enums.dart' as _i9;
import 'package:price_action_orders/domain/entities/api_access.dart' as _i10;
import 'package:price_action_orders/domain/entities/order.dart' as _i7;
import 'package:price_action_orders/domain/entities/ticker.dart' as _i8;
import 'package:price_action_orders/domain/entities/userdata.dart' as _i6;
import 'package:price_action_orders/domain/repositories/user_repository.dart'
    as _i3;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i3.UserRepository {
  MockUserRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.UserData>> getAccountInfo() =>
      (super.noSuchMethod(Invocation.method(#getAccountInfo, []),
              returnValue: Future<_i2.Either<_i5.Failure, _i6.UserData>>.value(
                  _FakeEither_0<_i5.Failure, _i6.UserData>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i6.UserData>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i7.Order>>> getOpenOrders() =>
      (super.noSuchMethod(Invocation.method(#getOpenOrders, []),
          returnValue: Future<_i2.Either<_i5.Failure, List<_i7.Order>>>.value(
              _FakeEither_0<_i5.Failure, List<_i7.Order>>())) as _i4
          .Future<_i2.Either<_i5.Failure, List<_i7.Order>>>);
  @override
  _i4.Future<_i2.Either<_i5.ServerFailure, _i4.Stream<dynamic>>>
      getUserDataStream() => (super.noSuchMethod(
              Invocation.method(#getUserDataStream, []),
              returnValue: Future<
                      _i2.Either<_i5.ServerFailure, _i4.Stream<dynamic>>>.value(
                  _FakeEither_0<_i5.ServerFailure, _i4.Stream<dynamic>>()))
          as _i4.Future<_i2.Either<_i5.ServerFailure, _i4.Stream<dynamic>>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i8.Ticker>> getLastTicker() =>
      (super.noSuchMethod(Invocation.method(#getLastTicker, []),
              returnValue: Future<_i2.Either<_i5.Failure, _i8.Ticker>>.value(
                  _FakeEither_0<_i5.Failure, _i8.Ticker>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i8.Ticker>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, Null?>> setLastTicker(
          _i8.Ticker? ticker) =>
      (super.noSuchMethod(Invocation.method(#setLastTicker, [ticker]),
              returnValue: Future<_i2.Either<_i5.Failure, Null?>>.value(
                  _FakeEither_0<_i5.Failure, Null?>()))
          as _i4.Future<_i2.Either<_i5.Failure, Null?>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, Null?>> checkAccountStatus(
          _i9.AppMode? mode, String? key, String? secret) =>
      (super.noSuchMethod(
              Invocation.method(#checkAccountStatus, [mode, key, secret]),
              returnValue: Future<_i2.Either<_i5.Failure, Null?>>.value(
                  _FakeEither_0<_i5.Failure, Null?>()))
          as _i4.Future<_i2.Either<_i5.Failure, Null?>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, Null?>> storeApiAccess(
          _i9.AppMode? mode, _i10.ApiAccess? apiAccess) =>
      (super.noSuchMethod(Invocation.method(#storeApiAccess, [mode, apiAccess]),
              returnValue: Future<_i2.Either<_i5.Failure, Null?>>.value(
                  _FakeEither_0<_i5.Failure, Null?>()))
          as _i4.Future<_i2.Either<_i5.Failure, Null?>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i10.ApiAccess>> getApiAccess(
          _i9.AppMode? mode) =>
      (super.noSuchMethod(Invocation.method(#getApiAccess, [mode]),
          returnValue: Future<_i2.Either<_i5.Failure, _i10.ApiAccess>>.value(
              _FakeEither_0<_i5.Failure, _i10.ApiAccess>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i10.ApiAccess>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, Null?>> clearApiAccess(
          _i9.AppMode? mode) =>
      (super.noSuchMethod(Invocation.method(#clearApiAccess, [mode]),
              returnValue: Future<_i2.Either<_i5.Failure, Null?>>.value(
                  _FakeEither_0<_i5.Failure, Null?>()))
          as _i4.Future<_i2.Either<_i5.Failure, Null?>>);
  @override
  String toString() => super.toString();
}
