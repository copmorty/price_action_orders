// Mocks generated by Mockito 5.0.15 from annotations
// in price_action_orders/test/presentation/logic/exchangeinfo_state_notifier_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:price_action_orders/core/error/failures.dart' as _i6;
import 'package:price_action_orders/core/usecases/usecase.dart' as _i8;
import 'package:price_action_orders/domain/entities/exchange_info.dart' as _i7;
import 'package:price_action_orders/domain/repositories/market_respository.dart'
    as _i2;
import 'package:price_action_orders/domain/usecases/market_get_exchangeinfo_uc.dart'
    as _i4;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeMarketRepository_0 extends _i1.Fake implements _i2.MarketRepository {
}

class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [GetExchangeInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetExchangeInfo extends _i1.Mock implements _i4.GetExchangeInfo {
  MockGetExchangeInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.MarketRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeMarketRepository_0()) as _i2.MarketRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i7.ExchangeInfo>> call(
          _i8.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
          returnValue: Future<_i3.Either<_i6.Failure, _i7.ExchangeInfo>>.value(
              _FakeEither_1<_i6.Failure, _i7.ExchangeInfo>())) as _i5
          .Future<_i3.Either<_i6.Failure, _i7.ExchangeInfo>>);
  @override
  String toString() => super.toString();
}
