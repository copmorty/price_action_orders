import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/order_cancel_response_model.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tCancelOrderResponseModel = CancelOrderResponseModel(
    symbol: 'BNBUSDT',
    origClientOrderId: 'gwwiVwQrlmxPiv4PAh5TT5',
    orderId: 4201377,
    orderListId: -1,
    clientOrderId: '8aDxzSltUbLhfEeNGacTz5',
    price: Decimal.parse('300.00000000'),
    origQty: Decimal.parse('300.00000000'),
    executedQty: Decimal.zero,
    cummulativeQuoteQty: Decimal.zero,
    status: BinanceOrderStatus.CANCELED,
    timeInForce: BinanceOrderTimeInForce.GTC,
    type: BinanceOrderType.LIMIT,
    side: BinanceOrderSide.SELL,
  );

  test(
    'should be a subclass of CancelOrderResponse',
    () {
      //assert
      expect(tCancelOrderResponseModel, isA<CancelOrderResponse>());
    },
  );

  test(
    'fromJson should return a valid CancelOrderResponseModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('cancel_order_response.json'));
      //act
      final result = CancelOrderResponseModel.fromJson(parsedJson);
      //assert
      expect(result, tCancelOrderResponseModel);
    },
  );
}
