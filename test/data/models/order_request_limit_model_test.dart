import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/order_request_limit_model.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

void main() {
  final tTimestamp = DateTime.now().millisecondsSinceEpoch;
  final tLimitOrderRequest = LimitOrderRequest(
    ticker: Ticker(baseAsset: 'BNB', quoteAsset: 'USDT'),
    side: BinanceOrderSide.BUY,
    timeInForce: BinanceOrderTimeInForce.GTC,
    quantity: Decimal.parse('2.4'),
    price: Decimal.parse('353'),
    timestamp: tTimestamp,
  );
  final tLimitOrderRequestModel = LimitOrderRequestModel(
    ticker: Ticker(baseAsset: 'BNB', quoteAsset: 'USDT'),
    side: BinanceOrderSide.BUY,
    timeInForce: BinanceOrderTimeInForce.GTC,
    quantity: Decimal.parse('2.4'),
    price: Decimal.parse('353'),
    timestamp: tTimestamp,
  );

  test(
    'should be a subclass of LimitOrderRequest',
    () {
      //assert
      expect(tLimitOrderRequestModel, isA<LimitOrderRequest>());
    },
  );

  test(
    'fromLimitOrderRequest should return a valid LimitOrderRequestModel',
    () {
      //act
      final result = LimitOrderRequestModel.fromLimitOrderRequest(tLimitOrderRequest);
      //assert
      expect(result, tLimitOrderRequestModel);
    },
  );

  test(
    'toJson should return a Json map containing the proper data',
    () {
      //act
      final result = tLimitOrderRequestModel.toJson();
      //assert
      final expectedMap = {
        'symbol': 'BNBUSDT',
        'side': 'BUY',
        'type': 'LIMIT',
        'timeInForce': 'GTC',
        'quantity': '2.4',
        'price': '353',
        'timestamp': tTimestamp.toString(),
      };

      expect(result, expectedMap);
    },
  );
}
