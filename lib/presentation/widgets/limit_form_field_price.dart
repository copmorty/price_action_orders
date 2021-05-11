import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/widgets/default_form_field.dart';

class PriceFormField extends StatelessWidget {
  final String quoteAsset;
  final TextEditingController priceController;
  final TextEditingController amountController;
  final TextEditingController totalController;
  final Function focusNext;
  final Function submitForm;

  const PriceFormField({
    Key key,
    @required this.quoteAsset,
    @required this.priceController,
    @required this.amountController,
    @required this.totalController,
    @required this.focusNext,
    @required this.submitForm,
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

  @override
  Widget build(BuildContext context) {
    return DefaultFormField(
      hintText: 'Price',
      suffixText: quoteAsset,
      controller: priceController,
      onChanged: _onChanged,
      onFieldSubmitted: _onFieldSubmitted,
    );
  }
}
