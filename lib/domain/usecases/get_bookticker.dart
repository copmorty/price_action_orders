import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';

class GetBookTicker implements UseCase<BookTicker, Params> {
  final BookTickerRepository repository;

  GetBookTicker(this.repository);

  @override
  Either<Failure, Stream<BookTicker>> call(Params params) {
    return repository.getBookTicker(params.symbol);
  }
}

class Params extends Equatable {
  final String symbol;

  Params(this.symbol);

  @override
  List<Object> get props => [symbol];
}
