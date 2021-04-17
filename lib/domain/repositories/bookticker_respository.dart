import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:meta/meta.dart';

abstract class BookTickerRepository {
  Future<Either<Failure, Stream<BookTicker>>> streamBookTicker({@required String baseAsset, @required String quoteAsset});
}
