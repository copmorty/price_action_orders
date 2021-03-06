import 'package:flutter/material.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'market_buy_form.dart';
import 'market_sell_form.dart';
import 'trade_form_header.dart';

class MarketBoard extends StatelessWidget {
  final String baseAsset;
  final String quoteAsset;

  const MarketBoard({
    Key? key,
    required this.baseAsset,
    required this.quoteAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              TradeFormHeader(baseAsset: baseAsset, quoteAsset: quoteAsset, side: BinanceOrderSide.BUY),
              SizedBox(height: 13),
              MarketBuyForm(baseAsset: baseAsset, quoteAsset: quoteAsset),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              TradeFormHeader(baseAsset: baseAsset, quoteAsset: quoteAsset, side: BinanceOrderSide.SELL),
              SizedBox(height: 13),
              MarketSellForm(baseAsset: baseAsset, quoteAsset: quoteAsset),
            ],
          ),
        ),
      ],
    );
  }
}
