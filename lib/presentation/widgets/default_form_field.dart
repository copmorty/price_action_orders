import 'package:flutter/material.dart';
import 'package:price_action_orders/core/util/formatters.dart';

class DefaultFormField extends StatelessWidget {
  final String hintText;
  final String suffixText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldValidator<String> validator;

  const DefaultFormField({
    Key key,
    @required this.hintText,
    @required this.suffixText,
    @required this.controller,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.all(Radius.circular(4))),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        cursorColor: Colors.white,
        inputFormatters: [
          ValidatorInputFormatter(
            editingValidator: DotCurrencyEditingRegexValidator(),
          )
        ],
        decoration: InputDecoration(
          hintText: hintText,
          suffixText: suffixText,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
        onChanged: onChanged == null ? null : (strPrice) => onChanged(strPrice),
        onFieldSubmitted: onFieldSubmitted == null ? null : (strPrice) => onFieldSubmitted(strPrice),
        validator: validator == null ? null : (strPrice) => validator(strPrice),
      ),
    );
  }
}