import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/order_request_stop_limit_model.dart';
import 'package:price_action_orders/domain/entities/order_request_stop_limit.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

void main() {
  final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
  final StopLimitOrderRequest tStopLimitOrder = StopLimitOrderRequest(
    ticker: tTicker,
    side: BinanceOrderSide.SELL,
    timeInForce: BinanceOrderTimeInForce.GTC,
    currentMarketPrice: Decimal.parse('340'),
    quantity: Decimal.parse('0.5'),
    price: Decimal.parse('338'),
    stopPrice: Decimal.parse('330'),
  );
  final tTimestamp = tStopLimitOrder.timestamp;
  final tStopLimitOrderRequestModel = StopLimitOrderRequestModel(
    ticker: tTicker,
    side: BinanceOrderSide.SELL,
    timeInForce: BinanceOrderTimeInForce.GTC,
    type: BinanceOrderType.STOP_LOSS_LIMIT,
    quantity: Decimal.parse('0.5'),
    price: Decimal.parse('338'),
    stopPrice: Decimal.parse('330'),
    timestamp: tTimestamp,
  );

  test(
    'should be a subclass of StopLimitOrderRequest',
    () {
      //assert
      expect(tStopLimitOrderRequestModel, isA<StopLimitOrderRequest>());
    },
  );

  test(
    'fromLimitOrderRequest should return a valid StopLimitOrderRequestModel',
    () {
      //act
      final result = StopLimitOrderRequestModel.fromStopLimitOrderRequest(tStopLimitOrder);
      //assert
      expect(result, tStopLimitOrderRequestModel);
    },
  );

  test(
    'toJson should return a Json map containing the proper data',
    () {
      //act
      final result = tStopLimitOrderRequestModel.toJson();
      //assert
      final expectedMap = {
        'symbol': 'BNBUSDT',
        'side': 'SELL',
        'type': 'STOP_LOSS_LIMIT',
        'timeInForce': 'GTC',
        'quantity': '0.5',
        'price': '338',
        'stopPrice': '330',
        'newOrderRespType': 'FULL',
        'timestamp': tTimestamp.toString(),
      };

      expect(result, expectedMap);
    },
  );
}
