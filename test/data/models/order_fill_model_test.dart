import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/data/models/order_fill_model.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tOrderFillModel = OrderFillModel(
    price: Decimal.parse('353'),
    quantity: Decimal.parse('0.10'),
    commission: Decimal.zero,
    commissionAsset: 'USDT',
    tradeId: 148752,
  );

  test(
    'should be a subclass of OrderFill',
    () {
      //assert
      expect(tOrderFillModel, isA<OrderFill>());
    },
  );

  test(
    'fromJsonStream should return a valid OrderFillModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('order_fill.json'));
      //act
      final result = OrderFillModel.fromJsonStream(parsedJson);
      //assert
      expect(result, tOrderFillModel);
    },
  );
}
