import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/util/formatters.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/presentation/bloc/order_bloc.dart';

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
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
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
          Container(
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.all(Radius.circular(4))),
            child: TextFormField(
              controller: _controller,
              cursorColor: Colors.white,
              inputFormatters: [
                ValidatorInputFormatter(
                  editingValidator: CommaCurrencyEditingRegexValidator(),
                )
              ],
              decoration: InputDecoration(
                hintText: 'Total',
                suffixText: widget.quoteAsset,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
              onFieldSubmitted: (_) => _marketBuy(),
            ),
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

  _marketBuy() {
    if (_controller.text == '') return;

    final symbol = widget.baseAsset + widget.quoteAsset;
    final quantity = Decimal.parse(_controller.text);
    final quoteOrderQty = null;
    final marketOrder = MarketOrder(symbol: symbol, side: BinanceOrderSide.BUY, quantity: quantity, quoteOrderQty: quoteOrderQty);
    
    _controller.clear();
    FocusScope.of(context).unfocus();
    BlocProvider.of<OrderBloc>(context).add(MarketOrderEvent(marketOrder));
  }
}