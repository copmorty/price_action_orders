import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/data/datasources/market_datasource.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import 'package:price_action_orders/domain/repositories/market_respository.dart';

class MarketRepositoryImpl implements MarketRepository {
  final MarketDataSource dataSource;

  MarketRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Stream<BookTicker>>> getBookTickerStream(Ticker ticker) async {
    try {
      final response = await dataSource.getBookTickerStream(ticker);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Stream<TickerStats>>> getTickerStatsStream(Ticker ticker) async {
    try {
      final response = await dataSource.getTickerStatsStream(ticker);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
