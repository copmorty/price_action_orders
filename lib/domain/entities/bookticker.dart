import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class BookTicker extends Equatable {
  final int updatedId;
  final String symbol;
  final Ticker ticker;
  final Decimal bidPrice; // best bid price
  final Decimal bidQty; // best bid qty
  final Decimal askPrice; // best ask price
  final Decimal askQty; // best ask qty

  BookTicker({
    @required this.updatedId,
    @required this.symbol,
    @required this.ticker,
    @required this.bidPrice,
    @required this.bidQty,
    @required this.askPrice,
    @required this.askQty,
  });

  @override
  List<Object> get props => [updatedId];
}
