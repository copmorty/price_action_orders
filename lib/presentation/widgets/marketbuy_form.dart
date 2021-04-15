import 'package:flutter/material.dart';
import 'package:price_action_orders/core/util/formatters.dart';

class MarketBuyForm extends StatelessWidget {
  final String baseAsset;
  final String quoteAsset;

  const MarketBuyForm({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

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
                  quoteAsset,
                  style: TextStyle(fontSize: 16, color: Colors.white60),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.all(Radius.circular(4))),
            child: TextFormField(
              cursorColor: Colors.white,
              inputFormatters: [
                ValidatorInputFormatter(
                  editingValidator: CommaCurrencyEditingRegexValidator(),
                )
              ],
              decoration: InputDecoration(
                hintText: 'Total',
                suffixText: quoteAsset,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Buy $baseAsset'),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
