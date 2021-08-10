import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/exchange_info.dart';
import 'package:price_action_orders/domain/usecases/get_market_exchange_info.dart';

part 'exchangeinfo_state.dart';

class ExchangeInfoNotifier extends StateNotifier<ExchangeInfoState> {
  final GetExchangeInfo _getExchangeInfo;

  ExchangeInfoNotifier(this._getExchangeInfo) : super(ExchangeInfoInitial());

  Future<Either<Failure, ExchangeInfo>> getExchangeInfo() async {
    if (state is ExchangeInfoLoaded)
      return Right((state as ExchangeInfoLoaded).exchangeInfo);
    else {
      state = ExchangeInfoLoading();

      final failureOrUserData = await _getExchangeInfo(NoParams());
      return failureOrUserData.fold(
        (failure) {
          state = ExchangeInfoError(failure.message);
          return Left(ServerFailure(message: failure.message));
        },
        (exchangeInfo) {
          state = ExchangeInfoLoaded(exchangeInfo);
          return Right(exchangeInfo);
        },
      );
    }
  }
}
