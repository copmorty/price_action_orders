import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';

class SetLastTicker implements UseCase<Null, Params> {
  final UserRepository repository;

  SetLastTicker(this.repository);

  @override
  Future<Either<Failure, Null>> call(params) async {
    return await repository.setLastTicker(params.ticker);
  }
}

class Params extends Equatable {
  final Ticker ticker;

  Params(this.ticker);

  @override
  List<Object> get props => [ticker];
}
