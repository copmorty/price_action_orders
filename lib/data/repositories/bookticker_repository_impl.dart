import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/data/datasources/bookticker_datasource.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';

class BookTickerRepositoryImpl implements BookTickerRepository {
  final BookTickerDataSource dataSource;

  BookTickerRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Stream<BookTicker>>> getBookTickerStream(Ticker ticker) async {
    try {
      final response = await dataSource.getBookTickerStream(ticker);
      dataSource.cacheLastTicker(ticker);
      return Right(response);
    } catch (e) {
      print('catchE');
      print(e); //Needs implementation on ui
      return Left(ServerFailure());
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
}
