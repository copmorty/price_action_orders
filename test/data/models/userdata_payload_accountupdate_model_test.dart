import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/userdata_payload_accountupdate_model.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tUserDataPayloadAccountUpdateModel = UserDataPayloadAccountUpdateModel(
    eventType: BinanceUserDataPayloadEventType.outboundAccountPosition,
    eventTime: 1564034571105,
    lastAccountUpdateTime: 1564034571073,
    changedBalances: [
      Balance(asset: 'ETH', free: Decimal.parse('10000.000000'), locked: Decimal.parse('0.000000')),
    ],
  );

  test(
    'should be a subclass of UserDataPayloadAccountUpdate',
    () async {
      //assert
      expect(tUserDataPayloadAccountUpdateModel, isA<UserDataPayloadAccountUpdate>());
    },
  );

  test(
    'fromJson should return a valid UserDataPayloadAccountUpdateModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('userdata_payload_accountupdate.json'));
      //act
      final result = UserDataPayloadAccountUpdateModel.fromJson(parsedJson);
      //assert
      expect(result, tUserDataPayloadAccountUpdateModel);
    },
  );
}
