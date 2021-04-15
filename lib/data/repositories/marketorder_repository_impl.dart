import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/data/datasources/marketorder_datasource.dart';
import 'package:price_action_orders/domain/repositories/marketorder_repository.dart';
import 'package:meta/meta.dart';

class MarketOrderRepositoryImpl implements MarketOrderRepository {
  final MarketOrderDataSource dataSource;

  MarketOrderRepositoryImpl({@required this.dataSource});

  @override
  Future<Either<Failure, dynamic>> postMarketOrder({
    @required String baseAsset,
    @required String quoteAsset,
    @required BinanceOrderSide side,
    @required Decimal quantity,
    @required Decimal quoteOrderQty,
  }) async {
    try {
      final response = await dataSource.postMarketOrder(
        baseAsset: baseAsset,
        quoteAsset: quoteAsset,
        side: side,
        quantity: quantity,
        quoteOrderQty: quoteOrderQty,
      );
    } on ServerException {
      // return Left(ServerFailure());
    }
  }
}
