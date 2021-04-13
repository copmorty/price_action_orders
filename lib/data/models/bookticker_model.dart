import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';

class BookTickerModel extends BookTicker {
  final int updatedId;
  final String symbol;
  final Decimal bidPrice; // best bid price
  final Decimal bidQty; // best bid qty
  final Decimal askPrice; // best ask price
  final Decimal askQty; // best ask qty

  BookTickerModel({
    @required this.updatedId,
    @required this.symbol,
    @required this.bidPrice,
    @required this.bidQty,
    @required this.askPrice,
    @required this.askQty,
  });

  
  @override
  List<Object> get props => [updatedId];

  factory BookTickerModel.fromStringifiedMap(String strMap) {
    final data = jsonDecode(strMap);

    return BookTickerModel(
      updatedId: data['u'],
      symbol: data['s'],
      bidPrice: Decimal.parse(data['b']),
      bidQty: Decimal.parse(data['B']),
      askPrice: Decimal.parse(data['a']),
      askQty: Decimal.parse(data['A']),
    );
  }
}
