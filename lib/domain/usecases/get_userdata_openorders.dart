import 'package:price_action_orders/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';

class GetOpenOrders extends UseCase<dynamic, NoParams> {
  final UserDataRepository repository;

  GetOpenOrders(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await repository.getOpenOrders();
  }
}
