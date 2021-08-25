import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import 'package:price_action_orders/domain/entities/order.dart' as entity;
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';

abstract class UserRepository {
  Future<Either<Failure, UserData>> getAccountInfo();
  Future<Either<Failure, List<entity.Order>>> getOpenOrders();
  Future<Either<ServerFailure, Stream<dynamic>>> getUserDataStream();
  Future<Either<Failure, Ticker>> getLastTicker();
  Future<Either<Failure, Null>> setLastTicker(Ticker ticker);
  Future<Either<Failure, Null>> checkAccountStatus(AppMode mode, String key, String secret);
  Future<Either<Failure, Null>> storeApiAccess(AppMode mode, ApiAccess apiAccess);
  Future<Either<Failure, ApiAccess>> getApiAccess(AppMode mode);
  Future<Either<Failure, Null>> clearApiAccess(AppMode mode);
}
