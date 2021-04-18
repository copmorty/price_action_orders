import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';

class OrderFillModel extends OrderFill {
  OrderFillModel({
    @required price,
    @required quantity,
    @required commission,
    @required commissionAsset,
  }) : super(price: price, quantity: quantity, commission: commission, commissionAsset: commissionAsset);

  factory OrderFillModel.fromJsonStream(Map<String, dynamic> parsedJson) {
    return OrderFillModel(
      price: Decimal.parse(parsedJson['price']),
      quantity: Decimal.parse(parsedJson['qty']),
      commission: Decimal.parse(parsedJson['commission']),
      commissionAsset: parsedJson['commissionAsset'],
    );
  }
}
