import 'package:flutter/material.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'stop_limit_form.dart';
import 'trade_form_header.dart';

class LimitBoard extends StatelessWidget {
  final String baseAsset;
  final String quoteAsset;

  const LimitBoard({
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
              StopLimitForm(appOrderType: AppOrderType.LIMIT, binanceOrderSide: BinanceOrderSide.BUY, baseAsset: baseAsset, quoteAsset: quoteAsset),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              TradeFormHeader(baseAsset: baseAsset, quoteAsset: quoteAsset, side: BinanceOrderSide.SELL),
              SizedBox(height: 13),
              StopLimitForm(appOrderType: AppOrderType.LIMIT, binanceOrderSide: BinanceOrderSide.SELL, baseAsset: baseAsset, quoteAsset: quoteAsset),
            ],
          ),
        ),
      ],
    );
  }
}
