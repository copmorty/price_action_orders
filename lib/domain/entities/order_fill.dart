import 'package:equatable/equatable.dart';
import 'package:decimal/decimal.dart';

class OrderFill extends Equatable {
  final Decimal/*!*/ price;
  final Decimal/*!*/ quantity;
  final Decimal/*!*/ commission;
  final String/*!*/ commissionAsset;
  final int/*!*/ tradeId;

  OrderFill({
    this.price,
    this.quantity,
    this.commission,
    this.commissionAsset,
    this.tradeId,
  });

  @override
  List<Object> get props => [tradeId];
}
