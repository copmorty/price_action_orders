import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/presentation/bloc/bookticker_bloc.dart';

class InputSymbol extends StatefulWidget {
  @override
  _InputSymbolState createState() => _InputSymbolState();
}

class _InputSymbolState extends State<InputSymbol> {
  TextEditingController _baseAssetController = TextEditingController();
  TextEditingController _quoteAssetcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _baseAssetController.dispose();
    _quoteAssetcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _baseAssetController,
            cursorColor: Colors.white,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Base asset',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onSubmitted: (_) => dispatchSymbol(),
            onChanged: (value) {
              _baseAssetController.text = value.toUpperCase();
              _baseAssetController.selection = TextSelection.fromPosition(TextPosition(offset: _baseAssetController.text.length));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('/'),
        ),
        Expanded(
          child: TextField(
            controller: _quoteAssetcontroller,
            cursorColor: Colors.white,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Quote asset',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onSubmitted: (_) => dispatchSymbol(),
            onChanged: (value) {
              _quoteAssetcontroller.text = value.toUpperCase();
              _quoteAssetcontroller.selection = TextSelection.fromPosition(TextPosition(offset: _quoteAssetcontroller.text.length));
            },
          ),
        ),
        IconButton(
          color: Colors.white70,
          icon: Icon(Icons.send),
          onPressed: dispatchSymbol,
        )
      ],
    );
  }

  void dispatchSymbol() {
    final baseAsset = _baseAssetController.text;
    final quoteAsset = _quoteAssetcontroller.text;

    if (baseAsset == '' || quoteAsset == '') return;

    _baseAssetController.clear();
    _quoteAssetcontroller.clear();
    FocusScope.of(context).unfocus();
    BlocProvider.of<BookTickerBloc>(context).add(StreamBookTickerEvent(Ticker(baseAsset: baseAsset, quoteAsset: quoteAsset)));
  }
}
