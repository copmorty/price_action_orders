import 'package:flutter/material.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/presentation/screens/home/controls_section/widgets/trade_form_header.dart';
import 'package:price_action_orders/presentation/screens/home/controls_section/widgets/market_buy_form.dart';
import 'package:price_action_orders/presentation/screens/home/controls_section/widgets/market_sell_form.dart';

class MarketBoard extends StatelessWidget {
  final String baseAsset;
  final String quoteAsset;

  const MarketBoard({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TradeFormHeader(baseAsset: baseAsset, quoteAsset: quoteAsset, side: BinanceOrderSide.BUY),
              SizedBox(height: 10),
              MarketBuyForm(baseAsset: baseAsset, quoteAsset: quoteAsset),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              TradeFormHeader(baseAsset: baseAsset, quoteAsset: quoteAsset, side: BinanceOrderSide.SELL),
              SizedBox(height: 10),
              MarketSellForm(baseAsset: baseAsset, quoteAsset: quoteAsset),
            ],
          ),
        ),
      ],
    );
  }
}