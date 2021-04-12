import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/data/datasources/userdata_datasource.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';
import 'package:meta/meta.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  final UserDataDataSource dataSource;

  UserDataRepositoryImpl({@required this.dataSource});

  @override
  Future<Either<Failure, UserData>> getUserData() async {
    try {
      final userData = await dataSource.getUserData();
      return Right(userData);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
