import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';

abstract class UserDataRepository {
  Future<Either<Failure, UserData>> getAccountInfo();
  Future<Either<Failure, dynamic>> getOpenOrders();
  Future<Either<ServerFailure, Stream<UserDataPayloadAccountUpdate>>> getUserDataStream();
}
