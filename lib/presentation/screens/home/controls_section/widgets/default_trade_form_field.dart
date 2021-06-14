import 'package:flutter/material.dart';
import 'package:price_action_orders/core/utils/formatters.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';

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
  bool _textFieldHasDecorator = false;

  void _onHover(bool isHovered) {
    setState(() {
      if (!_textFieldHasFocus) _textFieldHasDecorator = isHovered;
    });
  }

  void _onFocus(bool isFocused) {
    setState(() {
      _textFieldHasFocus = isFocused;
      _textFieldHasDecorator = _textFieldHasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedContainer(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        duration: Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: whiteColorOp10,
          border: Border.all(color: _textFieldHasDecorator ? whiteColorOp90 : transparentColor),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          children: [
            Text(
              widget.hintText,
              style: TextStyle(fontSize: 16, color: whiteColorOp60),
            ),
            Expanded(
              child: FocusScope(
                onFocusChange: (isFocused) => _onFocus(isFocused),
                child: TextFormField(
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  textAlign: TextAlign.end,
                  cursorColor: whiteColor,
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
              style: TextStyle(fontSize: 16, color: whiteColorOp60),
            ),
          ],
        ),
      ),
    );
  }
}
