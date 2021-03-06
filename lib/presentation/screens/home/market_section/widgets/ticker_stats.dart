import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import 'package:price_action_orders/presentation/logic/tickerstats_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/providers.dart';
import 'ticker_stats_change_info.dart';
import 'ticker_stats_info.dart';

class TickerStatsBoard extends ConsumerWidget {
  const TickerStatsBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final tickerStatsState = watch(tickerStatsNotifierProvider);

    if (tickerStatsState is TickerStatsInitial) return SizedBox();
    if (tickerStatsState is TickerStatsLoading) return LoadingWidget();
    if (tickerStatsState is TickerStatsError) return SizedBox();
    if (tickerStatsState is TickerStatsLoaded) return _TickerStatsDisplay(tickerStatsState.tickerStats);

    return SizedBox();
  }
}

class _TickerStatsDisplay extends StatelessWidget {
  final TickerStats tickerStats;

  const _TickerStatsDisplay(this.tickerStats, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TickerStatsChangeInfo(
          priceChange: tickerStats.priceChange,
          priceChangePercent: tickerStats.priceChangePercent,
          decimalDigits: currentTickerPriceDecimalDigits,
        ),
        TickerStatsInfo(label: '24h High', value: tickerStats.highPrice, decimalDigits: currentTickerPriceDecimalDigits),
        TickerStatsInfo(label: '24h Low', value: tickerStats.lowPrice, decimalDigits: currentTickerPriceDecimalDigits),
        TickerStatsInfo(label: '24h Volume(${tickerStats.ticker.baseAsset})', value: tickerStats.totalTradedBaseAssetVolume, decimalDigits: 2),
        TickerStatsInfo(label: '24h Volume(${tickerStats.ticker.quoteAsset})', value: tickerStats.totalTradedQuoteAssetVolume, decimalDigits: 2),
      ],
    );
  }
}
