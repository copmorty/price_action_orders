// Mocks generated by Mockito 5.0.10 from annotations
// in price_action_orders/test/presentation/logic/userdata_stream_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:price_action_orders/core/error/failures.dart' as _i6;
import 'package:price_action_orders/core/usecases/usecase.dart' as _i7;
import 'package:price_action_orders/domain/repositories/user_repository.dart'
    as _i2;
import 'package:price_action_orders/domain/usecases/get_user_datastream.dart'
    as _i4;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeUserRepository extends _i1.Fake implements _i2.UserRepository {}

class _FakeEither<L, R> extends _i1.Fake implements _i3.Either<L, R> {
  @override
  String toString() => super.toString();
}

/// A class which mocks [GetUserDataStream].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetUserDataStream extends _i1.Mock implements _i4.GetUserDataStream {
  MockGetUserDataStream() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeUserRepository()) as _i2.UserRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i5.Stream<dynamic>>> call(
          _i7.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue:
                  Future<_i3.Either<_i6.Failure, _i5.Stream<dynamic>>>.value(
                      _FakeEither<_i6.Failure, _i5.Stream<dynamic>>()))
          as _i5.Future<_i3.Either<_i6.Failure, _i5.Stream<dynamic>>>);
}