import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';

abstract class UserDataRepository {
  Future<Either<Failure, UserData>> getUserData();
}
