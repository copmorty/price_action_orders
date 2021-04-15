import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/util/formatters.dart';
import 'package:price_action_orders/presentation/bloc/order_bloc.dart';

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
                hintText: 'Amount',
                suffixText: widget.baseAsset,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
              onFieldSubmitted: (_) => _marketSell(),
            ),
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

  _marketSell() {
    if (_controller.text == '') return;
    
    final quantity = Decimal.parse(_controller.text);
    final quoteOrderQty = null;
    BlocProvider.of<OrderBloc>(context).add(MarketOrderEvent(widget.baseAsset, widget.quoteAsset, BinanceOrderSide.SELL, quantity, quoteOrderQty));
  }
}
