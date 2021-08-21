import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'ticker.dart';

class TickerStats extends Equatable {
  final String eventType;
  final int eventTime;
  final String symbol;
  final Decimal priceChange;
  final Decimal priceChangePercent;
  final Decimal weightedAveragePrice;
  final Decimal firstTradeBefore; //First trade(F)-1 price (first trade before the 24hr rolling window)
  final Decimal lastPrice;
  final Decimal lastQuantity;
  final Decimal bestBidPrice;
  final Decimal bestBidQuantity;
  final Decimal bestAskPrice;
  final Decimal bestAskQuantity;
  final Decimal openPrice;
  final Decimal highPrice;
  final Decimal lowPrice;
  final Decimal totalTradedBaseAssetVolume;
  final Decimal totalTradedQuoteAssetVolume;
  final int statisticsOpenTime;
  final int statisticsCloseTime;
  final int firstTradeId;
  final int lastTradeId;
  final int totalNumberOfTrades;
  final Ticker ticker;

  TickerStats({
    required this.eventType,
    required this.eventTime,
    required this.symbol,
    required this.priceChange,
    required this.priceChangePercent,
    required this.weightedAveragePrice,
    required this.firstTradeBefore,
    required this.lastPrice,
    required this.lastQuantity,
    required this.bestBidPrice,
    required this.bestBidQuantity,
    required this.bestAskPrice,
    required this.bestAskQuantity,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.totalTradedBaseAssetVolume,
    required this.totalTradedQuoteAssetVolume,
    required this.statisticsOpenTime,
    required this.statisticsCloseTime,
    required this.firstTradeId,
    required this.lastTradeId,
    required this.totalNumberOfTrades,
    required this.ticker,
  });

  @override
  List<Object> get props => [eventType, eventTime, symbol];
}
