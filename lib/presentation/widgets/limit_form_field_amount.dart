import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/widgets/default_form_field.dart';

class AmountFormField extends StatelessWidget {
  final String baseAsset;
  final FocusNode amountFocus;
  final TextEditingController priceController;
  final TextEditingController amountController;
  final TextEditingController totalController;
  final Function setCurrentPrice;
  final Function submitForm;

  const AmountFormField({
    Key key,
    @required this.baseAsset,
    @required this.amountFocus,
    @required this.priceController,
    @required this.amountController,
    @required this.totalController,
    @required this.setCurrentPrice,
    @required this.submitForm,
  }) : super(key: key);

  void _onChanged(strAmount) {
    if (priceController.text.isEmpty) setCurrentPrice();
    if (strAmount.isEmpty) {
      totalController.text = '';
    } else {
      final price = Decimal.parse(priceController.text);
      final amount = Decimal.parse(strAmount);
      totalController.text = (price * amount).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultFormField(
      hintText: 'Amount',
      suffixText: baseAsset,
      focusNode: amountFocus,
      controller: amountController,
      onChanged: _onChanged,
      onFieldSubmitted: (strVal) => submitForm,
    );
  }
}
