import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/order_model.dart';
import 'package:price_action_orders/domain/entities/order.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tOrderModel = OrderModel(
    symbol: 'BNBUSDT',
    orderId: 3543521,
    orderListId: -1,
    clientOrderId: '',
    price: Decimal.parse('353'),
    origQty: Decimal.one,
    executedQty: Decimal.parse('0.5'),
    cummulativeQuoteQty: Decimal.parse('176.5'),
    status: BinanceOrderStatus.PARTIALLY_FILLED,
    timeInForce: BinanceOrderTimeInForce.GTC,
    type: BinanceOrderType.LIMIT,
    side: BinanceOrderSide.SELL,
    stopPrice: Decimal.zero,
    icebergQty: Decimal.zero,
    time: 1623884531456,
    updateTime: 1623884531456,
    isWorking: true,
    origQuoteOrderQty: Decimal.zero,
  );

  test(
    'should be a subclass of Order',
    () {
      //assert
      expect(tOrderModel, isA<Order>());
    },
  );

  test(
    'fromJson should return a valid OrderModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('order.json'));
      //act
      final result = OrderModel.fromJson(parsedJson);
      //assert
      expect(result, tOrderModel);
    },
  );
}
