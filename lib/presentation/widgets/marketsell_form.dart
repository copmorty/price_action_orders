import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/presentation/widgets/default_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';

class MarketSellForm extends StatefulWidget {
  final String baseAsset;
  final String quoteAsset;

  const MarketSellForm({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  _MarketSellFormState createState() => _MarketSellFormState();
}

class _MarketSellFormState extends State<MarketSellForm> {
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
          // //timeInForce
          // Row(
          //   children: [
          //     DropdownButton(
          //       value: _timeInForce,
          //       onChanged: (val) => _selectTimeInForce(val),
          //       items: [
          //         DropdownMenuItem(
          //           child: Text('GTC'),
          //           value: BinanceOrderTimeInForce.GTC,
          //           onTap: () {},
          //         ),
          //         DropdownMenuItem(
          //           child: Text('IOC'),
          //           value: BinanceOrderTimeInForce.IOC,
          //           onTap: () {},
          //         ),
          //         DropdownMenuItem(
          //           child: Text('FOK'),
          //           value: BinanceOrderTimeInForce.FOK,
          //           onTap: () {},
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.all(Radius.circular(4))),
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
          DefaultFormField(
            hintText: 'Amount',
            suffixText: widget.baseAsset,
            controller: _controller,
            onFieldSubmitted: (_) => _marketSell(),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: _marketSell,
              child: Text('Sell ${widget.baseAsset}'),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _marketSell() {
    if (_controller.text == '') return;

    final quantityText = _controller.text.replaceAll(',', '.');
    final quantity = Decimal.parse(quantityText);
    final quoteOrderQty = null;
    final marketOrder = MarketOrder(
      ticker: Ticker(baseAsset: widget.baseAsset, quoteAsset: widget.quoteAsset),
      side: BinanceOrderSide.SELL,
      quantity: quantity,
      quoteOrderQty: quoteOrderQty,
    );

    _controller.clear();
    FocusScope.of(context).unfocus();
    context.read(orderNotifierProvider.notifier).postMarketOrder(marketOrder);
  }
}
