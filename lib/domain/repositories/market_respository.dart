import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/exchange_info.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';

abstract class MarketRepository {
  Future<Either<Failure, Stream<BookTicker>>> getBookTickerStream(Ticker ticker);
  Future<Either<Failure, Stream<TickerStats>>> getTickerStatsStream(Ticker ticker);
  Future<Either<Failure, ExchangeInfo>> getExchangeInfo();
}
