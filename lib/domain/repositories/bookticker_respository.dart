import 'package:price_action_orders/domain/entities/bookticker.dart';

abstract class BookTickerRepository {
  Stream<BookTicker> getBookTicker();
}
