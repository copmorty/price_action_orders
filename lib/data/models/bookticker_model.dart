import 'package:decimal/decimal.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class BookTickerModel extends BookTicker {
  BookTickerModel({
    required int updatedId,
    required String symbol,
    required Decimal bidPrice,
    required Decimal bidQty,
    required Decimal askPrice,
    required Decimal askQty,
    required Ticker ticker,
  }) : super(
          updatedId: updatedId,
          symbol: symbol,
          ticker: ticker,
          bidPrice: bidPrice,
          bidQty: bidQty,
          askPrice: askPrice,
          askQty: askQty,
        );

  factory BookTickerModel.fromJson(Map<String, dynamic> parsedJson, Ticker ticker) {
    return BookTickerModel(
      updatedId: parsedJson['u'],
      symbol: parsedJson['s'],
      bidPrice: Decimal.parse(parsedJson['b']),
      bidQty: Decimal.parse(parsedJson['B']),
      askPrice: Decimal.parse(parsedJson['a']),
      askQty: Decimal.parse(parsedJson['A']),
      ticker: ticker,
    );
  }
}
