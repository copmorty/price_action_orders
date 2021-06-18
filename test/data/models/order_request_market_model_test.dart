import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/order_request_market_model.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

void main() {
  final tTimestamp = DateTime.now().millisecondsSinceEpoch;
  final tMarketOrderRequest = MarketOrderRequest(
    ticker: Ticker(baseAsset: 'BNB', quoteAsset: 'USDT'),
    side: BinanceOrderSide.SELL,
    quantity: Decimal.parse('2.4'),
    timestamp: tTimestamp,
  );
  final tMarketOrderRequestModel = MarketOrderRequestModel(
    ticker: Ticker(baseAsset: 'BNB', quoteAsset: 'USDT'),
    side: BinanceOrderSide.SELL,
    quantity: Decimal.parse('2.4'),
    timestamp: tTimestamp,
  );

  test(
    'should be a subclass of MarketOrderRequest',
    () async {
      //assert
      expect(tMarketOrderRequestModel, isA<MarketOrderRequest>());
    },
  );

  test(
    'fromMarketOrderRequest should return a valid MarketOrderRequestModel',
    () async {
      //act
      final result = MarketOrderRequestModel.fromMarketOrderRequest(tMarketOrderRequest);
      //assert
      expect(result, tMarketOrderRequestModel);
    },
  );

  test(
    'toJson should return a Json map containing the proper data',
    () async {
      //act
      final result = tMarketOrderRequestModel.toJson();
      //assert
      final expectedMap = {
        'symbol': 'BNBUSDT',
        'side': 'SELL',
        'type': 'MARKET',
        'quantity': '2.4',
        'timestamp': tTimestamp.toString(),
      };

      expect(result, expectedMap);
    },
  );
}
