import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/userdata_payload_orderupdate_model.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_orderupdate.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tUserDataPayloadOrderUpdateModel = UserDataPayloadOrderUpdateModel(
    eventType: BinanceUserDataPayloadEventType.executionReport,
    eventTime: 1499405658658,
    symbol: 'ETHBTC',
    clientOrderId: 'mUvoqJxFIILMdfAW5iGSOW',
    side: BinanceOrderSide.BUY,
    orderType: BinanceOrderType.LIMIT,
    timeInForce: BinanceOrderTimeInForce.GTC,
    orderQuantity: Decimal.parse('1.00000000'),
    orderPrice: Decimal.parse('0.10264410'),
    stopPrice: Decimal.parse('0.00000000'),
    icebergQuantity: Decimal.parse('0.00000000'),
    orderListId: -1,
    originalClientOrderId: '',
    currentExecutionType: BinanceOrderExecutionType.NEW,
    currentOrderStatus: BinanceOrderStatus.NEW,
    orderRejectReason: 'NONE',
    orderId: 4293153,
    lastExecutedQuantity: Decimal.parse('0.00000000'),
    cumulativeFilledQuantity: Decimal.parse('0.00000000'),
    lastExecutedPrice: Decimal.parse('0.00000000'),
    commisionAmount: Decimal.zero,
    commisionAsset: 'ETH',
    transactionTime: 1499405658657,
    tradeId: -1,
    orderIsOnTheBook: true,
    tradeIsTheMakerSide: false,
    orderCreationTime: 1499405658657,
    cumulativeQuoteAssetTransactedQuantity: Decimal.parse('0.00000000'),
    lastQuoteAssetTransactedQuantity: Decimal.parse('0.00000000'),
    quoteOrderQuantity: Decimal.parse('0.00000000'),
  );

  test(
    'should be a subclass of UserDataPayloadOrderUpdate',
    () {
      //assert
      expect(tUserDataPayloadOrderUpdateModel, isA<UserDataPayloadOrderUpdate>());
    },
  );

  test(
    'fromJson should return a valid UserDataPayloadOrderUpdateModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('userdata_payload_orderupdate.json'));
      //act
      final result = UserDataPayloadOrderUpdateModel.fromJson(parsedJson);
      //assert
      expect(result, tUserDataPayloadOrderUpdateModel);
    },
  );
}
