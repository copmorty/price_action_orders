import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/data/models/balance_model.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tBalanceModel = BalanceModel(asset: 'BNB', free: Decimal.parse('1000'), locked: Decimal.zero);

  test(
    'should be a subclass of Balance',
    () {
      //assert
      expect(tBalanceModel, isA<Balance>());
    },
  );

  test(
    'fromJson should return a valid BalanceModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('balance.json'));
      //act
      final result = BalanceModel.fromJson(parsedJson);
      //assert
      expect(result, tBalanceModel);
    },
  );

  test(
    'fromJsonStream should return a valid BalanceModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('balance_from_stream.json'));
      //act
      final result = BalanceModel.fromJsonStream(parsedJson);
      //assert
      expect(result, tBalanceModel);
    },
  );

}
