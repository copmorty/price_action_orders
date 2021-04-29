import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'default_form_field.dart';

class TotalFormField extends StatelessWidget {
  final String quoteAsset;
  final TextEditingController priceController;
  final TextEditingController amountController;
  final TextEditingController totalController;
  final Function setCurrentPrice;
  final Function submitForm;

  const TotalFormField({
    Key key,
    @required this.quoteAsset,
    @required this.priceController,
    @required this.amountController,
    @required this.totalController,
    @required this.setCurrentPrice,
    @required this.submitForm,
  }) : super(key: key);

  void _onChanged(strTotal) {
    if (priceController.text.isEmpty) setCurrentPrice();
    if (strTotal.isEmpty) {
      amountController.text = '';
    } else {
      final price = Decimal.parse(priceController.text);
      final total = Decimal.parse(strTotal);
      amountController.text = (total / price).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultFormField(
      hintText: 'Total',
      suffixText: quoteAsset,
      controller: totalController,
      onChanged: _onChanged,
      onFieldSubmitted: (strVal) => submitForm,
    );
  }
}
