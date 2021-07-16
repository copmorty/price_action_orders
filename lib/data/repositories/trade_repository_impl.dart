import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/data/datasources/trade_datasource.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/repositories/trade_repository.dart';

class TradeRepositoryImpl implements TradeRepository {
  final TradeDataSource/*!*/ dataSource;

  TradeRepositoryImpl(this.dataSource);

  @override
  Future<Either<ServerFailure, OrderResponseFull>> postMarketOrder(MarketOrderRequest marketOrder) async {
    try {
      final response = await dataSource.postMarketOrder(marketOrder);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<ServerFailure, OrderResponseFull>> postLimitOrder(LimitOrderRequest limitOrder) async {
    try {
      final response = await dataSource.postLimitOrder(limitOrder);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<ServerFailure, CancelOrderResponse>> postCancelOrder(CancelOrderRequest cancelOrder) async {
    try {
      final response = await dataSource.postCancelOrder(cancelOrder);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
