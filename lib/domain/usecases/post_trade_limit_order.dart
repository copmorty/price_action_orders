import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/repositories/trade_repository.dart';

class PostLimitOrder implements UseCase<OrderResponseFull, Params> {
  final TradeRepository/*!*/ repository;

  PostLimitOrder(this.repository);

  @override
  Future<Either<Failure, OrderResponseFull>> call(Params params) async {
    return await repository.postLimitOrder(params.limitOrder);
  }
}

class Params extends Equatable {
  final LimitOrderRequest limitOrder;

  Params(this.limitOrder);

  @override
  List<Object> get props => [limitOrder];
}
