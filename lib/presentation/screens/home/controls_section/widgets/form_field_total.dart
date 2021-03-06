import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'default_trade_form_field.dart';

class TotalFormField extends StatelessWidget {
  final String quoteAsset;
  final TextEditingController controller;
  final TextEditingController priceController;
  final TextEditingController amountController;
  final Function setCurrentPrice;
  final Function submitForm;

  const TotalFormField({
    Key? key,
    required this.quoteAsset,
    required this.controller,
    required this.priceController,
    required this.amountController,
    required this.setCurrentPrice,
    required this.submitForm,
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
      controller: controller,
      onChanged: _onChanged,
      onFieldSubmitted: (strVal) => submitForm(),
    );
  }
}
