import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/data/models/bookticker_model.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
  final tBookTickerModel = BookTickerModel(
    updatedId: 1623853890857,
    symbol: 'BNBUSDT',
    ticker: tTicker,
    bidPrice: Decimal.parse('353'),
    bidQty: Decimal.parse('1.42'),
    askPrice: Decimal.parse('353.45'),
    askQty: Decimal.parse('1.42'),
  );

  test(
    'should be a subclass of BookTicker',
    () {
      //assert
      expect(tBookTickerModel, isA<BookTicker>());
    },
  );

  test(
    'fromJson should return a valid BookTickerModel',
    () async {
      //arrange
      final parsedJson = jsonDecode(attachment('bookticker.json'));
      //act
      final result = BookTickerModel.fromJson(parsedJson, tTicker);
      //assert
      expect(result, tBookTickerModel);
    },
  );
}
