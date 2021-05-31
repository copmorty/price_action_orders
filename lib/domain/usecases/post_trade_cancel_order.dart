import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import 'package:price_action_orders/domain/repositories/trade_repository.dart';

class PostCancelOrder implements UseCase<CancelOrderResponse, Params> {
  final TradeRepository repository;

  PostCancelOrder(this.repository);

  @override
  Future<Either<Failure, CancelOrderResponse>> call(Params params) async {
    return await repository.cancelOrder(params.cancelOrder);
  }
}

class Params extends Equatable {
  final CancelOrderRequest cancelOrder;

  Params(this.cancelOrder);

  @override
  List<Object> get props => [cancelOrder];
}
