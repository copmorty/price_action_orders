import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'default_trade_form_field.dart';

class PriceFormField extends StatelessWidget {
  final String? hintText;
  final String quoteAsset;
  final FocusNode focusNode;
  final TextEditingController controller;
  final TextEditingController amountController;
  final TextEditingController totalController;
  final Function focusNext;
  final Function submitForm;

  const PriceFormField({
    Key? key,
    this.hintText,
    required this.quoteAsset,
    required this.focusNode,
    required this.controller,
    required this.amountController,
    required this.totalController,
    required this.focusNext,
    required this.submitForm,
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

  String? _validator(String? strPrice) {
    if (!(strPrice is String)) return 'Invalid input';
    if (strPrice.isEmpty) return 'Please input price';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTradeFormField(
      hintText: hintText ?? 'Price',
      suffixText: quoteAsset,
      focusNode: focusNode,
      controller: controller,
      onChanged: _onChanged,
      onFieldSubmitted: _onFieldSubmitted,
      validator: _validator,
    );
  }
}
