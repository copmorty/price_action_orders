import 'package:decimal/decimal.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class BookTickerModel extends BookTicker {
  BookTickerModel({
    int/*!*/ updatedId,
    String/*!*/ symbol,
    Ticker/*!*/ ticker,
    Decimal/*!*/ bidPrice,
    Decimal/*!*/ bidQty,
    Decimal/*!*/ askPrice,
    Decimal/*!*/ askQty,
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
      ticker: ticker,
      bidPrice: Decimal.parse(parsedJson['b']),
      bidQty: Decimal.parse(parsedJson['B']),
      askPrice: Decimal.parse(parsedJson['a']),
      askQty: Decimal.parse(parsedJson['A']),
    );
  }
}
