import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/data/models/ticker_model.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
  final tTickerModel = TickerModel(baseAsset: 'BNB', quoteAsset: 'USDT');

  test(
    'should be a subclass of Ticker',
    () {
      //assert
      expect(tTickerModel, isA<Ticker>());
    },
  );

  test(
    'fromTicker should return a valid TickerModel',
    () {
      //act
      final result = TickerModel.fromTicker(tTicker);
      //assert
      expect(result, tTickerModel);
    },
  );

  test(
    'fromJson should return a valid TickerModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('ticker.json'));
      //act
      final result = TickerModel.fromJson(parsedJson);
      //assert
      expect(result, tTickerModel);
    },
  );

  test(
    'toJson should return a Json map containing the proper data',
    () {
      //act
      final result = tTickerModel.toJson();
      //assert
      final expectedMap = {
        'baseAsset': 'BNB',
        'quoteAsset': 'USDT',
      };

      expect(result, expectedMap);
    },
  );
}
