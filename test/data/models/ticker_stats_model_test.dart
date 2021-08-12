import 'dart:convert';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/data/models/ticker_stats_model.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'BTC');
  final tTickerStatsModel = TickerStatsModel(
    eventType: '24hrTicker',
    eventTime: 1627653272369,
    symbol: 'BNBUSDT',
    priceChange: Decimal.parse('0.47000000'),
    priceChangePercent: Decimal.parse('0.152'),
    weightedAveragePrice: Decimal.parse('309.34940953'),
    firstTradeBefore: Decimal.parse('0.00000000'),
    lastPrice: Decimal.parse('309.61000000'),
    lastQuantity: Decimal.parse('1.62000000'),
    bestBidPrice: Decimal.parse('308.44000000'),
    bestBidQuantity: Decimal.parse('309.62000000'),
    bestAskPrice: Decimal.parse('309.62000000'),
    bestAskQuantity: Decimal.parse('1.62000000'),
    openPrice: Decimal.parse('309.14000000'),
    highPrice: Decimal.parse('310.83000000'),
    lowPrice: Decimal.parse('231.62000000'),
    totalTradedBaseAssetVolume: Decimal.parse('6501.72000000'),
    totalTradedQuoteAssetVolume: Decimal.parse('2011303.24290000'),
    statisticsOpenTime: 1627566872368,
    statisticsCloseTime: 1627653272368,
    firstTradeId: 0,
    lastTradeId: 4042,
    totalNumberOfTrades: 4043,
    ticker: tTicker,
  );

  test(
    'should be a subclass of TickerStats',
    () {
      //assert
      expect(tTickerStatsModel, isA<TickerStats>());
    },
  );

  test(
    'fromJson should return a valid TickerStatsModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('ticker_stats.json'));
      //act
      final result = TickerStatsModel.fromJson(parsedJson, tTicker);
      //assert
      expect(result, tTickerStatsModel);
    },
  );
}
