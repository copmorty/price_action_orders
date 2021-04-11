import 'package:price_action_orders/data/datasources/bookticker_datasource.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';
import 'package:meta/meta.dart';

class BookTickerRepositoryImpl implements BookTickerRepository {
  final BookTickerDataSource dataSource;

  BookTickerRepositoryImpl({@required this.dataSource});

  @override
  Stream<BookTicker> getBookTicker() {
    return dataSource.getBookTicker();
  }
}
