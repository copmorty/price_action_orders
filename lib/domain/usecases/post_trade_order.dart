import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order_request.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/repositories/trade_repository.dart';

class PostOrder implements UseCase<OrderResponseFull, Params> {
  final TradeRepository repository;

  PostOrder(this.repository);

  @override
  Future<Either<Failure, OrderResponseFull>> call(Params params) async {
    return await repository.postOrder(params.order);
  }
}

class Params extends Equatable {
  final OrderRequest order;

  Params(this.order);

  @override
  List<Object> get props => [order];
}
