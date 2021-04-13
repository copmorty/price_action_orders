import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class BookTicker extends Equatable {
  final int updatedId;
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final Decimal bidPrice; // best bid price
  final Decimal bidQty; // best bid qty
  final Decimal askPrice; // best ask price
  final Decimal askQty; // best ask qty

  BookTicker({
    @required this.updatedId,
    @required this.symbol,
    @required this.baseAsset,
    @required this.quoteAsset,
    @required this.bidPrice,
    @required this.bidQty,
    @required this.askPrice,
    @required this.askQty,
  });

  @override
  List<Object> get props => [updatedId];
}
