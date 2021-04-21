import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/core/util/formatters.dart';
import 'package:price_action_orders/presentation/bloc/bookticker_bloc.dart';

class LimitBuyForm extends StatefulWidget {
  final String baseAsset;
  final String quoteAsset;

  const LimitBuyForm({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  _LimitBuyFormState createState() => _LimitBuyFormState();
}

class _LimitBuyFormState extends State<LimitBuyForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  _onFormSubmitted() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.all(Radius.circular(4))),
            child: TextFormField(
              controller: _priceController,
              cursorColor: Colors.white,
              inputFormatters: [
                ValidatorInputFormatter(
                  editingValidator: DotCurrencyEditingRegexValidator(),
                )
              ],
              decoration: InputDecoration(
                hintText: 'Price',
                suffixText: widget.quoteAsset,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
              onChanged: (strPrice) {
                if (strPrice.isEmpty) {
                  _totalController.text = '';
                } else if (_amountController.text.isNotEmpty) {
                  final price = Decimal.parse(strPrice);
                  final amount = Decimal.parse(_amountController.text);
                  _totalController.text = (price * amount).toString();
                }
              },
              onFieldSubmitted: (_) {
                if (_amountController.text.isEmpty || _totalController.text.isEmpty) {
                  FocusScope.of(context).requestFocus(_amountFocus);
                } else
                  _onFormSubmitted();
              },
              validator: (value) {
                // if (value.isEmpty) {
                //   return 'This field cannot be empty';
                // }
                return null;
              },
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.all(Radius.circular(4))),
            child: TextFormField(
              controller: _amountController,
              focusNode: _amountFocus,
              cursorColor: Colors.white,
              inputFormatters: [
                ValidatorInputFormatter(
                  editingValidator: DotCurrencyEditingRegexValidator(),
                )
              ],
              decoration: InputDecoration(
                hintText: 'Amount',
                suffixText: widget.baseAsset,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
              onChanged: (strAmount) {
                if (_priceController.text.isEmpty) {
                  final bookTickerState = BlocProvider.of<BookTickerBloc>(context).state;
                  if (bookTickerState is LoadedBookTicker) {
                    final currentPrice = (bookTickerState.bookTicker.bidPrice + bookTickerState.bookTicker.askPrice) / Decimal.fromInt(2);
                    _priceController.text = currentPrice.toString();
                  } else
                    return;
                }
                if (strAmount.isEmpty) {
                  _totalController.text = '';
                } else {
                  final price = Decimal.parse(_priceController.text);
                  final amount = Decimal.parse(strAmount);
                  _totalController.text = (price * amount).toString();
                }
              },
              onFieldSubmitted: (_) => _onFormSubmitted,
              validator: (value) {
                // if (value.isEmpty) {
                //   return 'This field cannot be empty';
                // }
                return null;
              },
            ),
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.all(Radius.circular(4))),
            child: TextFormField(
              controller: _totalController,
              cursorColor: Colors.white,
              inputFormatters: [
                ValidatorInputFormatter(
                  editingValidator: DotCurrencyEditingRegexValidator(),
                )
              ],
              decoration: InputDecoration(
                hintText: 'Total',
                suffixText: widget.quoteAsset,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
              onChanged: (strTotal) {
                if (_priceController.text.isEmpty) {
                  final bookTickerState = BlocProvider.of<BookTickerBloc>(context).state;
                  if (bookTickerState is LoadedBookTicker) {
                    final currentPrice = (bookTickerState.bookTicker.bidPrice + bookTickerState.bookTicker.askPrice) / Decimal.fromInt(2);
                    _priceController.text = currentPrice.toString();
                  } else
                    return;
                }
                if (strTotal.isEmpty) {
                  _amountController.text = '';
                } else {
                  final price = Decimal.parse(_priceController.text);
                  final total = Decimal.parse(strTotal);
                  _amountController.text = (total / price).toString();
                }
              },
              onFieldSubmitted: (_) => _onFormSubmitted,
              validator: (value) {
                // if (value.isEmpty) {
                //   return 'This field cannot be empty';
                // }
                return null;
              },
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: _onFormSubmitted,
              child: Text('Buy ${widget.baseAsset}'),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
