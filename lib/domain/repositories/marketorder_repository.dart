import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';

abstract class MarketOrderRepository {
  Future<Either<Failure, OrderResponseFull>> postMarketOrder(MarketOrder marketOrder);
}
