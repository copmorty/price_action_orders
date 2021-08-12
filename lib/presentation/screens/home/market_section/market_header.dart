import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/presentation/logic/ticker_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/providers.dart';
import 'widgets/input_symbol.dart';
import 'widgets/ticker_stats.dart';
import 'widgets/current_ticker.dart';

class MarketHeader extends ConsumerWidget {
  const MarketHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final tickerState = watch(tickerNotifierProvider);

    if (tickerState is TickerInitial) return InputSymbol();
    if (tickerState is TickerLoading) return LoadingWidget();
    if (tickerState is TickerLoaded) return _MarketHeaderDisplay(tickerState.ticker);

    return SizedBox();
  }
}

class _MarketHeaderDisplay extends StatelessWidget {
  final Ticker ticker;

  const _MarketHeaderDisplay(this.ticker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CurrentTicker(baseAsset: ticker.baseAsset, quoteAsset: ticker.quoteAsset),
            ),
            Expanded(
              flex: 8,
              child: TickerStatsBoard(),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
