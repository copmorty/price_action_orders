import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';

class GetApiAccess implements UseCase<ApiAccess, Params> {
  final UserRepository repository;

  GetApiAccess(this.repository);

  @override
  Future<Either<Failure, ApiAccess>> call(Params params) async {
    return await repository.getApiAccess(params.mode);
  }
}

class Params extends Equatable {
  final AppMode mode;

  Params(this.mode);

  @override
  List<Object> get props => [mode];
}
