import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/data/datasources/userdata_datasource.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';
import 'package:price_action_orders/domain/entities/order.dart' as entity;

class UserDataRepositoryImpl implements UserDataRepository {
  final UserDataDataSource dataSource;

  UserDataRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserData>> getAccountInfo() async {
    try {
      final userData = await dataSource.getAccountInfo();
      return Right(userData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<entity.Order>>> getOpenOrders() async {
    try {
      final response = await dataSource.getOpenOrders();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<ServerFailure, Stream<dynamic>>> getUserDataStream() async {
    try {
      final result = await dataSource.getUserDataStream();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
