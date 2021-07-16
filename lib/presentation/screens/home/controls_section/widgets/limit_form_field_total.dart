import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'default_trade_form_field.dart';

class TotalFormField extends StatelessWidget {
  final String/*!*/ quoteAsset;
  final TextEditingController/*!*/ priceController;
  final TextEditingController/*!*/ amountController;
  final TextEditingController/*!*/ totalController;
  final Function/*!*/ setCurrentPrice;
  final Function/*!*/ submitForm;

  const TotalFormField({
    Key key,
    this.quoteAsset,
    this.priceController,
    this.amountController,
    this.totalController,
    this.setCurrentPrice,
    this.submitForm,
  }) : super(key: key);

  void _onChanged(strTotal) {
    if (priceController.text.isEmpty) setCurrentPrice();
    if (strTotal.isEmpty) {
      amountController.text = '';
    } else if (priceController.text.isNotEmpty) {
      final price = Decimal.parse(priceController.text);
      final total = Decimal.parse(strTotal);
      amountController.text = (total / price).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTradeFormField(
      hintText: 'Total',
      suffixText: quoteAsset,
      controller: totalController,
      onChanged: _onChanged,
      onFieldSubmitted: (strVal) => submitForm,
    );
  }
}
