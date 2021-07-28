import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/screens/home/market_section/input_symbol.dart';
import 'package:price_action_orders/presentation/shared/sizes.dart';
import 'market_section/bookticker.dart';
import 'market_section/ticker_stats.dart';

class MarketSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SECTION_PADDING_ALL),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(flex: 4, child: InputSymbol()),
              Expanded(flex: 6, child: TickerStatsBoard()),
            ],
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: BookTickerBoard(),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
