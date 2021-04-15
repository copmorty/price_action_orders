import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/globals/enums.dart';

abstract class MarketOrderRepository {
  Future<Either<Failure, dynamic>> postMarketOrder({
    @required String baseAsset,
    @required String quoteAsset,
    @required BinanceOrderSide side,
    @required Decimal quantity,
    @required Decimal quoteOrderQty,
  });
}
