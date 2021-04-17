import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';
import 'package:meta/meta.dart';

class StreamBookTicker implements UseCase<BookTicker, Params> {
  final BookTickerRepository repository;

  StreamBookTicker(this.repository);

  @override
  Future<Either<Failure, Stream<BookTicker>>> call(Params params) async {
    return await repository.streamBookTicker(baseAsset: params.baseAsset, quoteAsset: params.quoteAsset);
  }
}

class Params extends Equatable {
  final String baseAsset;
  final String quoteAsset;

  Params({@required this.baseAsset, @required this.quoteAsset});

  @override
  List<Object> get props => [baseAsset, quoteAsset];
}
