import 'package:price_action_orders/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/order.dart' as entity;
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';

class GetOpenOrders extends UseCase<List<entity.Order>, NoParams> {
  final UserDataRepository repository;

  GetOpenOrders(this.repository);

  @override
  Future<Either<Failure, List<entity.Order>>> call(params) async {
    return await repository.getOpenOrders();
  }
}
