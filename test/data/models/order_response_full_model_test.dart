import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/order_response_full_model.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tTicker = Ticker(baseAsset: 'BTC', quoteAsset: 'USDT');
  final tOrderResponseFullModel = OrderResponseFullModel(
    ticker: tTicker,
    symbol: 'BTCUSDT',
    orderId: 28,
    orderListId: -1,
    clientOrderId: '',
    transactTime: 1507725176595,
    price: Decimal.parse('0.00000000'),
    origQty: Decimal.parse('10.00000000'),
    executedQty: Decimal.parse('10.00000000'),
    cummulativeQuoteQty: Decimal.parse('10.00000000'),
    status: BinanceOrderStatus.FILLED,
    timeInForce: BinanceOrderTimeInForce.GTC,
    type: BinanceOrderType.MARKET,
    side: BinanceOrderSide.SELL,
    fills: [
      OrderFill(
        price: Decimal.parse('4000.00000000'),
        quantity: Decimal.parse('1.00000000'),
        commission: Decimal.parse('4.00000000'),
        commissionAsset: 'USDT',
        tradeId: 1,
      ),
      OrderFill(
        price: Decimal.parse('3999.00000000'),
        quantity: Decimal.parse('5.00000000'),
        commission: Decimal.parse('19.99500000'),
        commissionAsset: 'USDT',
        tradeId: 2,
      ),
      OrderFill(
        price: Decimal.parse('3998.00000000'),
        quantity: Decimal.parse('2.00000000'),
        commission: Decimal.parse('7.99600000'),
        commissionAsset: 'USDT',
        tradeId: 3,
      ),
      OrderFill(
        price: Decimal.parse('3997.00000000'),
        quantity: Decimal.parse('1.00000000'),
        commission: Decimal.parse('3.99700000'),
        commissionAsset: 'USDT',
        tradeId: 4,
      ),
      OrderFill(
        price: Decimal.parse('3995.00000000'),
        quantity: Decimal.parse('1.00000000'),
        commission: Decimal.parse('3.99500000'),
        commissionAsset: 'USDT',
        tradeId: 5,
      ),
    ],
  );

  test(
    'should be a subclass of OrderResponseFull',
    () {
      //assert
      expect(tOrderResponseFullModel, isA<OrderResponseFullModel>());
    },
  );

  test(
    'fromJson should return a valid OrderResponseFullModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('order_response_full.json'));
      //act
      final result = OrderResponseFullModel.fromJson(parsedJson, tTicker);
      //assert
      expect(result, tOrderResponseFullModel);
    },
  );
}
