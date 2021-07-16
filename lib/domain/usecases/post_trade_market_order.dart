import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/repositories/trade_repository.dart';

class PostMarketOrder implements UseCase<OrderResponseFull, Params> {
  final TradeRepository/*!*/ repository;

  PostMarketOrder(this.repository);

  @override
  Future<Either<Failure, OrderResponseFull>> call(Params params) async {
    return await repository.postMarketOrder(params.marketOrder);
  }
}

class Params extends Equatable {
  final MarketOrderRequest marketOrder;

  Params(this.marketOrder);

  @override
  List<Object> get props => [marketOrder];
}
