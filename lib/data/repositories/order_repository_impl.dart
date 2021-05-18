import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/data/datasources/order_datasource.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource dataSource;

  OrderRepositoryImpl(this.dataSource);

  @override
  Future<Either<ServerFailure, OrderResponseFull>> postMarketOrder(MarketOrderRequest marketOrder) async {
    try {
      final response = await dataSource.postMarketOrder(marketOrder);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, OrderResponseFull>> postLimitOrder(LimitOrderRequest limitOrder) async {
    try {
      final response = await dataSource.postLimitOrder(limitOrder);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, CancelOrderResponse>> cancelOrder(CancelOrderRequest cancelOrder) async {
    try {
      final response = await dataSource.postCancelOrder(cancelOrder);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
