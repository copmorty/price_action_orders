import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/data/models/userdata_model.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tUserDataModel = UserDataModel(
    updateTime: 123456789,
    makerCommission: 15,
    takerCommission: 15,
    buyerCommission: 0,
    sellerCommission: 0,
    canTrade: true,
    canWithdraw: true,
    canDeposit: true,
    accountType: 'SPOT',
    balances: [
      Balance(asset: 'BTC', free: Decimal.parse('4723846.89208129'), locked: Decimal.parse('0.00000000')),
      Balance(asset: 'LTC', free: Decimal.parse('4763368.68006011'), locked: Decimal.parse('0.00000000')),
    ],
    permissions: ['SPOT'],
  );

  test(
    'should be a subclass of UserData',
    () async {
      //assert
      expect(tUserDataModel, isA<UserData>());
    },
  );

  test(
    'fromJson should return a valid UserDataModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('userdata.json'));
      //act
      final result = UserDataModel.fromJson(parsedJson);
      //assert
      expect(result, tUserDataModel);
    },
  );
}
