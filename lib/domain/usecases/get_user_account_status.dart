import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';

class CheckAccountStatus implements UseCase<dynamic, Params> {
  final UserRepository repository;

  CheckAccountStatus(this.repository);

  @override
  Future<Either<Failure, Null>> call(params) async {
    return await repository.checkAccountStatus(params.mode, params.key, params.secret);
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
