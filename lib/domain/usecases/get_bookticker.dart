import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';

class GetBookTicker implements UseCase<BookTicker> {
  final BookTickerRepository repository;

  GetBookTicker(this.repository);
  @override
  Stream<BookTicker> call() {
    return repository.getBookTicker();
  }
}
