import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/bookticker_bloc.dart';

class InputSymbol extends StatefulWidget {
  @override
  _InputSymbolState createState() => _InputSymbolState();
}

class _InputSymbolState extends State<InputSymbol> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      cursorColor: Colors.white,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        hintText: 'Put a symbol',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: IconButton(
          color: Colors.white70,
          icon: Icon(Icons.send),
          onPressed: dispatchSymbol,
        ),
      ),
      onSubmitted: (_) => dispatchSymbol(),
      onChanged: (value) {
        _controller.text = value.toUpperCase();
        _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
      },
    );
  }

  void dispatchSymbol() {
    String symbol = _controller.text;
    if (symbol != '') {
      _controller.clear();
      FocusScope.of(context).unfocus();
      BlocProvider.of<BookTickerBloc>(context).add(StreamBookTickerEvent(symbol));
    }
  }
}
