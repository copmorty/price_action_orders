import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/widgets/buyheader_widget.dart';
import 'package:price_action_orders/presentation/widgets/marketbuy_form.dart';
import 'package:price_action_orders/presentation/widgets/marketsell_form.dart';
import 'package:price_action_orders/presentation/widgets/sellheader_widget.dart';

class MarketOrderSection extends StatelessWidget {
  final String baseAsset;
  final String quoteAsset;

  const MarketOrderSection({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              BuyHeader(baseAsset: baseAsset, quoteAsset: quoteAsset),
              SizedBox(height: 10),
              MarketBuyForm(baseAsset: baseAsset, quoteAsset: quoteAsset),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              SellHeader(baseAsset: baseAsset, quoteAsset: quoteAsset),
              SizedBox(height: 10),
              MarketSellForm(baseAsset: baseAsset, quoteAsset: quoteAsset),
            ],
          ),
        ),
      ],
    );
  }
}