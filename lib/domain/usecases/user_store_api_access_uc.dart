import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';

class StoreApiAccess implements UseCase<Null, Params> {
  final UserRepository repository;

  StoreApiAccess(this.repository);

  @override
  Future<Either<Failure, Null>> call(Params params) async {
    return await repository.storeApiAccess(params.mode, ApiAccess(key: params.key, secret: params.secret));
  }
}

class Params extends Equatable {
  final AppMode mode;
  final String key;
  final String secret;

  Params(this.mode, this.key, this.secret);

  @override
  List<Object> get props => [mode, key, secret];
}
