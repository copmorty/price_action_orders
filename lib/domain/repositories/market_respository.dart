import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

abstract class MarketRepository {
  Future<Either<Failure, Stream<BookTicker>>> getBookTickerStream(Ticker ticker);
  Future<Either<Failure, Ticker>> getLastTicker();
}
