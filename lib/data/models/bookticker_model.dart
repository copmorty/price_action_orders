import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class BookTickerModel extends BookTicker {
  BookTickerModel({
    @required int updatedId,
    @required String symbol,
    @required Ticker ticker,
    @required Decimal bidPrice,
    @required Decimal bidQty,
    @required Decimal askPrice,
    @required Decimal askQty,
  }) : super(
          updatedId: updatedId,
          symbol: symbol,
          ticker: ticker,
          bidPrice: bidPrice,
          bidQty: bidQty,
          askPrice: askPrice,
          askQty: askQty,
        );

  @override
  List<Object> get props => [updatedId];

  factory BookTickerModel.fromStringifiedMap({@required String strMap, @required Ticker ticker}) {
    final data = jsonDecode(strMap);

    return BookTickerModel(
      updatedId: data['u'],
      symbol: data['s'],
      ticker: ticker,
      bidPrice: Decimal.parse(data['b']),
      bidQty: Decimal.parse(data['B']),
      askPrice: Decimal.parse(data['a']),
      askQty: Decimal.parse(data['A']),
    );
  }
}
