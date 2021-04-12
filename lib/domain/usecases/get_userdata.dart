import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';

class GetUserData implements UseCase<UserData, NoParams> {
  final UserDataRepository repository;

  GetUserData(this.repository);

  @override
  Future<Either<Failure, UserData>> call(params) async {
    return await repository.getUserData();
  }
}
