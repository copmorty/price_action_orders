import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';

abstract class BookTickerRepository {
  Either<Failure, Stream<BookTicker>> getBookTicker(String symbol);
}
