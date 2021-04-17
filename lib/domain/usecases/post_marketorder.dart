import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/repositories/marketorder_repository.dart';

class PostMarketOrder implements UseCase<MarketOrder, Params> {
  MarketOrderRepository repository;

  PostMarketOrder(this.repository);

  @override
  Future<Either<ServerFailure, OrderResponseFull>> call(Params params) async {
    return await repository.postMarketOrder(params.marketOrder);
  }
}

class Params extends Equatable {
  final MarketOrder marketOrder;

  Params({@required this.marketOrder});

  @override
  List<Object> get props => [marketOrder];
}