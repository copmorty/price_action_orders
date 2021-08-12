import 'package:flutter/material.dart';
import 'default_trade_form_field.dart';

class StopPriceFormField extends StatelessWidget {
  final String quoteAsset;
  final TextEditingController controller;
  final TextEditingController priceController;
  final TextEditingController amountController;
  final TextEditingController totalController;
  final Function focusNext;
  final Function submitForm;

  const StopPriceFormField({
    Key? key,
    required this.quoteAsset,
    required this.controller,
    required this.priceController,
    required this.amountController,
    required this.totalController,
    required this.focusNext,
    required this.submitForm,
  }) : super(key: key);


  void _onFieldSubmitted(String strPrice) {
    if (priceController.text.isEmpty || amountController.text.isEmpty || totalController.text.isEmpty)
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
      hintText: 'Stop',
      suffixText: quoteAsset,
      controller: controller,
      onFieldSubmitted: _onFieldSubmitted,
      validator: _validator,
    );
  }
}
