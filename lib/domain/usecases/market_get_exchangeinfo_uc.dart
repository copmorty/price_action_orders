import 'package:price_action_orders/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/exchange_info.dart';
import 'package:price_action_orders/domain/repositories/market_respository.dart';

class GetExchangeInfo implements UseCase<ExchangeInfo, NoParams> {
  final MarketRepository repository;

  GetExchangeInfo(this.repository);

  @override
  Future<Either<Failure, ExchangeInfo>> call(NoParams params) async {
    return await repository.getExchangeInfo();
  }
}
