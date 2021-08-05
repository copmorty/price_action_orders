import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/shared/sizes.dart';
import 'market_section/bookticker.dart';
import 'market_section/market_header.dart';

class MarketSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SECTION_PADDING_ALL),
      child: Column(
        children: [
          MarketHeader(),
          BookTickerBoard(),
        ],
      ),
    );
  }
}
