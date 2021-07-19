// Mocks generated by Mockito 5.0.10 from annotations
// in price_action_orders/test/data/repositories/trade_repository_impl_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:price_action_orders/data/datasources/trade_datasource.dart'
    as _i4;
import 'package:price_action_orders/domain/entities/order_cancel_request.dart'
    as _i8;
import 'package:price_action_orders/domain/entities/order_cancel_response.dart'
    as _i3;
import 'package:price_action_orders/domain/entities/order_request_limit.dart'
    as _i7;
import 'package:price_action_orders/domain/entities/order_request_market.dart'
    as _i6;
import 'package:price_action_orders/domain/entities/order_response_full.dart'
    as _i2;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeOrderResponseFull extends _i1.Fake implements _i2.OrderResponseFull {
}

class _FakeCancelOrderResponse extends _i1.Fake
    implements _i3.CancelOrderResponse {}

/// A class which mocks [TradeDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockTradeDataSource extends _i1.Mock implements _i4.TradeDataSource {
  MockTradeDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.OrderResponseFull> postMarketOrder(
          _i6.MarketOrderRequest? marketOrder) =>
      (super.noSuchMethod(Invocation.method(#postMarketOrder, [marketOrder]),
              returnValue:
                  Future<_i2.OrderResponseFull>.value(_FakeOrderResponseFull()))
          as _i5.Future<_i2.OrderResponseFull>);
  @override
  _i5.Future<_i2.OrderResponseFull> postLimitOrder(
          _i7.LimitOrderRequest? limitOrder) =>
      (super.noSuchMethod(Invocation.method(#postLimitOrder, [limitOrder]),
              returnValue:
                  Future<_i2.OrderResponseFull>.value(_FakeOrderResponseFull()))
          as _i5.Future<_i2.OrderResponseFull>);
  @override
  _i5.Future<_i3.CancelOrderResponse> postCancelOrder(
          _i8.CancelOrderRequest? cancelOrder) =>
      (super.noSuchMethod(Invocation.method(#postCancelOrder, [cancelOrder]),
              returnValue: Future<_i3.CancelOrderResponse>.value(
                  _FakeCancelOrderResponse()))
          as _i5.Future<_i3.CancelOrderResponse>);
}
