import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/data/datasources/marketorder_datasource.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/repositories/marketorder_repository.dart';
import 'package:meta/meta.dart';

class MarketOrderRepositoryImpl implements MarketOrderRepository {
  final MarketOrderDataSource dataSource;

  MarketOrderRepositoryImpl({@required this.dataSource});

  @override
  Future<Either<ServerFailure, OrderResponseFull>> postMarketOrder(MarketOrder marketOrder) async {
    try {
      final response = await dataSource.postMarketOrder(marketOrder);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}