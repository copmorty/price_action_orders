import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/repositories/marketorder_repository.dart';

class PostMarketOrder implements UseCase<MarketOrder, Params> {
  MarketOrderRepository repository;

  PostMarketOrder(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(Params params) async {
    return await repository.postMarketOrder(
      baseAsset: params.baseAsset,
      quoteAsset: params.quoteAsset,
      side: params.side,
      quantity: params.quantity,
      quoteOrderQty: params.quoteOrderQty,
    );
  }
}

class Params extends Equatable {
  final String baseAsset;
  final String quoteAsset;
  final BinanceOrderSide side;
  final Decimal quantity;
  final Decimal quoteOrderQty;

  Params({
    @required this.baseAsset,
    @required this.quoteAsset,
    @required this.side,
    @required this.quantity,
    @required this.quoteOrderQty,
  });

  @override
  List<Object> get props => [baseAsset, quoteAsset, side, quantity, quoteOrderQty];
}
