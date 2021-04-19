import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

abstract class BookTickerRepository {
  Future<Either<Failure, Stream<BookTicker>>> streamBookTicker(Ticker ticker);
  Future<Either<Failure, Ticker>> getLastTicker();
}
