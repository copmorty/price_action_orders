import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';

class GetAccountInfo implements UseCase<UserData, NoParams> {
  final UserRepository/*!*/ repository;

  GetAccountInfo(this.repository);

  @override
  Future<Either<Failure, UserData>> call(params) async {
    return await repository.getAccountInfo();
  }
}
