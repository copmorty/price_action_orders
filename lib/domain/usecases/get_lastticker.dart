import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';

class GetLastTicker implements UseCase<Ticker, NoParams> {
  final BookTickerRepository repository;

  GetLastTicker(this.repository);

  @override
  Future<Either<Failure, Ticker>> call(params) async {
    return await repository.getLastTicker();
  }
}
