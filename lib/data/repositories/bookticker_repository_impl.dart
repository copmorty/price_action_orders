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
  Future<Either<Failure, Stream<BookTicker>>> streamBookTicker({@required baseAsset, @required quoteAsset}) async{
    try {
      final response = await dataSource.streamBookTicker(baseAsset: baseAsset, quoteAsset: quoteAsset);
      print('response');
      print(response);
      return Right(response);
    } catch (e) {
      print('catchE');
      print(e);
      return Left(ServerFailure());
    }
  }
}
