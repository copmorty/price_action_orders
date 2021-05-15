import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';

abstract class OrderRepository {
  Future<Either<ServerFailure, OrderResponseFull>> postMarketOrder(MarketOrderRequest marketOrder);
  Future<Either<ServerFailure, OrderResponseFull>> postLimitOrder(LimitOrderRequest limitOrder);
}
