import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/entities/order.dart' as entity;

abstract class UserRepository {
  Future<Either<Failure, UserData>> getAccountInfo();
  Future<Either<Failure, List<entity.Order>>> getOpenOrders();
  Future<Either<ServerFailure, Stream<dynamic>>> getUserDataStream();
}
