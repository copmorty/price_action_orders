import 'package:decimal/decimal.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';

class OrderFillModel extends OrderFill {
  OrderFillModel({
    required Decimal price,
    required Decimal quantity,
    required Decimal commission,
    required String commissionAsset,
    required int tradeId,
  }) : super(
          price: price,
          quantity: quantity,
          commission: commission,
          commissionAsset: commissionAsset,
          tradeId: tradeId,
        );

  factory OrderFillModel.fromJsonStream(Map<String, dynamic> parsedJson) {
    return OrderFillModel(
      price: Decimal.parse(parsedJson['price']),
      quantity: Decimal.parse(parsedJson['qty']),
      commission: Decimal.parse(parsedJson['commission']),
      commissionAsset: parsedJson['commissionAsset'],
      tradeId: parsedJson['tradeId'],
    );
  }
}
