import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/rational.dart';

class BookTickerModel extends BookTicker {
  final int updatedId;
  final String symbol;
  final Rational bidPrice; // best bid price
  final Rational bidQty; // best bid qty
  final Rational askPrice; // best ask price
  final Rational askQty; // best ask qty

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
      bidPrice: Rational.parse(data['b']),
      bidQty: Rational.parse(data['B']),
      askPrice: Rational.parse(data['a']),
      askQty: Rational.parse(data['A']),
    );
  }
}
