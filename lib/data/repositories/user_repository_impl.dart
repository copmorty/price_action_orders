import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/datasources/user_datasource.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/repositories/user_repository.dart';
import 'package:price_action_orders/domain/entities/order.dart' as entity;

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserData>> getAccountInfo() async {
    try {
      final userData = await dataSource.getAccountInfo();
      return Right(userData);
    } catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<entity.Order>>> getOpenOrders() async {
    try {
      final response = await dataSource.getOpenOrders();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<ServerFailure, Stream<dynamic>>> getUserDataStream() async {
    try {
      final result = await dataSource.getUserDataStream();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Ticker>> getLastTicker() async {
    try {
      final ticker = await dataSource.getLastTicker();
      return Right(ticker);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Null>> setLastTicker(Ticker ticker) async {
    try {
      await dataSource.cacheLastTicker(ticker);
      return Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Null>> checkAccountStatus(AppMode mode, String key, String secret) async {
    try {
      await dataSource.checkAccountStatus(mode, key, secret);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
