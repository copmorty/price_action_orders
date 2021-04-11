import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/rational.dart';

class BookTicker extends Equatable {
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

  @override
  List<Object> get props => [updatedId];
}
