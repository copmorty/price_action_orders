import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import 'package:price_action_orders/domain/entities/order_request.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';

abstract class TradeRepository {
  Future<Either<ServerFailure, OrderResponseFull>> postOrder(OrderRequest order);
  Future<Either<ServerFailure, CancelOrderResponse>> cancelOrder(CancelOrderRequest cancelOrder);
}
