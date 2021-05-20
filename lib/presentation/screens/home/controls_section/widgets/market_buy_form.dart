import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'default_trade_form_field.dart';

class MarketBuyForm extends StatefulWidget {
  final String baseAsset;
  final String quoteAsset;

  const MarketBuyForm({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  _MarketBuyFormState createState() => _MarketBuyFormState();
}

class _MarketBuyFormState extends State<MarketBuyForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white10,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Price',
                    style: TextStyle(fontSize: 16, color: Colors.white60),
                  ),
                ),
                Text(
                  'Market',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Text(
                  widget.quoteAsset,
                  style: TextStyle(fontSize: 16, color: Colors.white60),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          DefaultTradeFormField(
            hintText: 'Total',
            suffixText: widget.quoteAsset,
            controller: _controller,
            onFieldSubmitted: (_) => _marketBuy(),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: _marketBuy,
              child: Text('Buy ${widget.baseAsset}'),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  void _marketBuy() {
    if (_controller.text == '') return;

    final quantity = null;
    final quoteOrderQtyText = _controller.text.replaceAll(',', '.');
    final quoteOrderQty = Decimal.parse(quoteOrderQtyText);
    final marketOrder = MarketOrderRequest(
      ticker: Ticker(baseAsset: widget.baseAsset, quoteAsset: widget.quoteAsset),
      side: BinanceOrderSide.BUY,
      quantity: quantity,
      quoteOrderQty: quoteOrderQty,
    );

    _controller.clear();
    FocusScope.of(context).unfocus();
    context.read(orderRequestNotifierProvider.notifier).postMarketOrder(marketOrder);
  }
}
