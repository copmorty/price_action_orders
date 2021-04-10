import 'package:meta/meta.dart';
import 'dart:convert';

final _pattern = RegExp(r'^([+-]?\d*)(\.\d*)?([eE][+-]?\d+)?$');

class BookTicker {
  final int updatedId;
  final String symbol;
  final Rational bidPrice; // best bid price
  final Rational bidQty; // best bid qty
  final Rational askPrice; // best ask price
  final Rational askQty; // best ask qty

  BookTicker({
    @required this.updatedId,
    @required this.symbol,
    @required this.bidPrice,
    @required this.bidQty,
    @required this.askPrice,
    @required this.askQty,
  });

  factory BookTicker.fromStringifiedMap(String strMap) {
    final data = jsonDecode(strMap);

    return BookTicker(
      updatedId: data['u'],
      symbol: data['s'],
      bidPrice: Rational.parse(data['b']),
      bidQty: Rational.parse(data['B']),
      askPrice: Rational.parse(data['a']),
      askQty: Rational.parse(data['A']),
    );
  }
}

class Rational {
  final int integerPart;
  final int decimalPart;

  Rational(this.integerPart, this.decimalPart);

  static parse(String strNumber) {
    final match = _pattern.firstMatch(strNumber);

    if (match == null) {
      throw FormatException();
    }

    final dotIndex = strNumber.indexOf('.');
    final intPart = int.parse(strNumber.substring(0, dotIndex));
    final decPart =
        int.parse(strNumber.substring(dotIndex + 1, strNumber.length));

    return Rational(intPart, decPart);
  }

  String toString() {
    return integerPart.toString() + '.' + decimalPart.toString();
  }
}
