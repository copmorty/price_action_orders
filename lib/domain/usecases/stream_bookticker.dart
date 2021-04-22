import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';

class StreamBookTicker implements UseCase<Stream<BookTicker>, Params> {
  final BookTickerRepository repository;

  StreamBookTicker(this.repository);

  @override
  Future<Either<Failure, Stream<BookTicker>>> call(Params params) async {
    return await repository.streamBookTicker(params.ticker);
  }
}

class Params extends Equatable {
  final Ticker ticker;

  Params(this.ticker);

  @override
  List<Object> get props => [ticker];
}
