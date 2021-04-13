import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/data/datasources/bookticker_datasource.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';
import 'package:meta/meta.dart';

class BookTickerRepositoryImpl implements BookTickerRepository {
  final BookTickerDataSource dataSource;

  BookTickerRepositoryImpl({@required this.dataSource});

  @override
  Either<Failure, Stream<BookTicker>> streamBookTicker({@required baseAsset, @required quoteAsset}) {
    try {
      return Right(dataSource.streamBookTicker(baseAsset: baseAsset, quoteAsset: quoteAsset));
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
