import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';

class InputSymbol extends StatefulWidget {
  final bool minimize;

  const InputSymbol({Key? key, this.minimize = false}) : super(key: key);

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

  void _submitTicker() {
    final baseAsset = _baseAssetController.text;
    final quoteAsset = _quoteAssetcontroller.text;

    if (baseAsset == '' || quoteAsset == '') return;

    _baseAssetController.clear();
    _quoteAssetcontroller.clear();
    FocusScope.of(context).unfocus();
    context.read(stateHandlerProvider).dispatchTicker(Ticker(baseAsset: baseAsset, quoteAsset: quoteAsset));
  }

  @override
  Widget build(BuildContext context) {
    return widget.minimize
        ? _InputSmall(
            baseAssetController: _baseAssetController,
            quoteAssetcontroller: _quoteAssetcontroller,
            submitTicker: _submitTicker,
          )
        : _InputNormal(
            baseAssetController: _baseAssetController,
            quoteAssetcontroller: _quoteAssetcontroller,
            submitTicker: _submitTicker,
          );
  }
}

class _InputNormal extends StatelessWidget {
  final TextEditingController baseAssetController;
  final TextEditingController quoteAssetcontroller;
  final void Function() submitTicker;

  const _InputNormal({
    Key? key,
    required this.baseAssetController,
    required this.quoteAssetcontroller,
    required this.submitTicker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                controller: baseAssetController,
                cursorColor: whiteColor,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Base asset',
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: whiteColor)),
                ),
                onSubmitted: (_) => submitTicker(),
                onChanged: (value) {
                  baseAssetController.text = value.toUpperCase();
                  baseAssetController.selection = TextSelection.fromPosition(TextPosition(offset: baseAssetController.text.length));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('/'),
            ),
            Expanded(
              child: TextField(
                textAlign: TextAlign.center,
                controller: quoteAssetcontroller,
                cursorColor: whiteColor,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'Quote asset',
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: whiteColor)),
                ),
                onSubmitted: (_) => submitTicker(),
                onChanged: (value) {
                  quoteAssetcontroller.text = value.toUpperCase();
                  quoteAssetcontroller.selection = TextSelection.fromPosition(TextPosition(offset: quoteAssetcontroller.text.length));
                },
              ),
            ),
            IconButton(
              color: whiteColorOp70,
              icon: Icon(Icons.send),
              splashRadius: 25,
              onPressed: submitTicker,
            )
          ],
        ),
        SizedBox(height: 16),
        Text('Please enter Base & Quote assets'),
      ],
    );
  }
}

class _InputSmall extends StatelessWidget {
  final TextEditingController baseAssetController;
  final TextEditingController quoteAssetcontroller;
  final void Function() submitTicker;

  const _InputSmall({
    Key? key,
    required this.baseAssetController,
    required this.quoteAssetcontroller,
    required this.submitTicker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColorOp10,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
              controller: baseAssetController,
              cursorColor: whiteColor,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'Base asset',
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onSubmitted: (_) => submitTicker(),
              onChanged: (value) {
                baseAssetController.text = value.toUpperCase();
                baseAssetController.selection = TextSelection.fromPosition(TextPosition(offset: baseAssetController.text.length));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('/'),
          ),
          Expanded(
            child: TextField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
              controller: quoteAssetcontroller,
              cursorColor: whiteColor,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'Quote asset',
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onSubmitted: (_) => submitTicker(),
              onChanged: (value) {
                quoteAssetcontroller.text = value.toUpperCase();
                quoteAssetcontroller.selection = TextSelection.fromPosition(TextPosition(offset: quoteAssetcontroller.text.length));
              },
            ),
          ),
          IconButton(
            iconSize: 14,
            color: whiteColorOp70,
            icon: Icon(Icons.send),
            splashRadius: 25,
            onPressed: submitTicker,
          )
        ],
      ),
    );
  }
}
