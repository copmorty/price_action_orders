import 'package:flutter/material.dart';
import 'package:price_action_orders/core/utils/formatters.dart';

class DefaultTradeFormField extends StatefulWidget {
  final String hintText;
  final String suffixText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldValidator<String> validator;

  const DefaultTradeFormField({
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
  _DefaultTradeFormFieldState createState() => _DefaultTradeFormFieldState();
}

class _DefaultTradeFormFieldState extends State<DefaultTradeFormField> {
  bool _textFieldHasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white10,
        border: Border.all(color: _textFieldHasFocus ? Colors.white : Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          Text(
            widget.hintText,
            style: TextStyle(fontSize: 16, color: Colors.white60),
          ),
          Expanded(
            child: FocusScope(
              onFocusChange: (isFocused) => setState(() => _textFieldHasFocus = isFocused),
              child: TextFormField(
                focusNode: widget.focusNode,
                controller: widget.controller,
                textAlign: TextAlign.end,
                cursorColor: Colors.white,
                inputFormatters: [
                  ValidatorInputFormatter(
                    editingValidator: DotCurrencyEditingRegexValidator(),
                  )
                ],
                decoration: InputDecoration(border: InputBorder.none),
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onFieldSubmitted,
                validator: widget.validator,
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            widget.suffixText,
            style: TextStyle(fontSize: 16, color: Colors.white60),
          ),
        ],
      ),
    );
  }
}
