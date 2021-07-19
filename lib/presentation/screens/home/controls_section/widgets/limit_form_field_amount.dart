import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'default_trade_form_field.dart';

class AmountFormField extends StatelessWidget {
  final String baseAsset;
  final FocusNode amountFocus;
  final TextEditingController priceController;
  final TextEditingController amountController;
  final TextEditingController totalController;
  final Function setCurrentPrice;
  final Function submitForm;

  const AmountFormField({
    Key? key,
    required this.baseAsset,
    required this.amountFocus,
    required this.priceController,
    required this.amountController,
    required this.totalController,
    required this.setCurrentPrice,
    required this.submitForm,
  }) : super(key: key);

  void _onChanged(strAmount) {
    if (priceController.text.isEmpty) setCurrentPrice();
    if (strAmount.isEmpty) {
      totalController.text = '';
    } else if (priceController.text.isNotEmpty) {
      final price = Decimal.parse(priceController.text);
      final amount = Decimal.parse(strAmount);
      totalController.text = (price * amount).toString();
    }
  }

  String? _validator(String? strAmount) {
    if (!(strAmount is String)) return 'Invalid input';
    if (strAmount.isEmpty) return 'Please input amount';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTradeFormField(
      hintText: 'Amount',
      suffixText: baseAsset,
      focusNode: amountFocus,
      controller: amountController,
      onChanged: _onChanged,
      onFieldSubmitted: (strVal) => submitForm,
      validator: _validator,
    );
  }
}
