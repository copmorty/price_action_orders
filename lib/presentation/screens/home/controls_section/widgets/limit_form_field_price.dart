import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'default_trade_form_field.dart';

class PriceFormField extends StatelessWidget {
  final String/*!*/ quoteAsset;
  final TextEditingController/*!*/ priceController;
  final TextEditingController/*!*/ amountController;
  final TextEditingController/*!*/ totalController;
  final Function/*!*/ focusNext;
  final Function/*!*/ submitForm;

  const PriceFormField({
    Key key,
    this.quoteAsset,
    this.priceController,
    this.amountController,
    this.totalController,
    this.focusNext,
    this.submitForm,
  }) : super(key: key);

  void _onChanged(String strPrice) {
    if (strPrice.isEmpty) {
      totalController.text = '';
    } else if (amountController.text.isNotEmpty) {
      final price = Decimal.parse(strPrice);
      final amount = Decimal.parse(amountController.text);
      totalController.text = (price * amount).toString();
    }
  }

  void _onFieldSubmitted(String strPrice) {
    if (amountController.text.isEmpty || totalController.text.isEmpty)
      focusNext();
    else
      submitForm();
  }

  String _validator(String strPrice) {
    if (strPrice.isEmpty) return 'Please input price';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTradeFormField(
      hintText: 'Price',
      suffixText: quoteAsset,
      controller: priceController,
      onChanged: _onChanged,
      onFieldSubmitted: _onFieldSubmitted,
      validator: _validator,
    );
  }
}
