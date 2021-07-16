import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';

class GetUserDataStream implements UseCase<Stream<dynamic>, NoParams> {
  final UserRepository/*!*/ repository;

  GetUserDataStream(this.repository);

  @override
  Future<Either<Failure, Stream<dynamic>>> call(params) async {
    return await repository.getUserDataStream();
  }
}
