import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import 'package:price_action_orders/domain/repositories/market_respository.dart';

class GetTickerStatsStream extends UseCase<Stream<TickerStats>, Params> {
  final MarketRepository repository;

  GetTickerStatsStream(this.repository);

  @override
  Future<Either<Failure, Stream<TickerStats>>> call(Params params) async {
    return await repository.getTickerStatsStream(params.ticker);
  }
}

class Params extends Equatable {
  final Ticker ticker;

  Params(this.ticker);

  @override
  List<Object> get props => [ticker];
}
