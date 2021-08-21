import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

class OrderFill extends Equatable {
  final Decimal price;
  final Decimal quantity;
  final Decimal commission;
  final String commissionAsset;
  final int tradeId;

  OrderFill({
    required this.price,
    required this.quantity,
    required this.commission,
    required this.commissionAsset,
    required this.tradeId,
  });

  @override
  List<Object> get props => [tradeId];
}
