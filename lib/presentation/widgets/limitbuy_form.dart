import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/bookticker_bloc.dart';
import 'package:price_action_orders/presentation/widgets/limitbuy_form_field_amount.dart';
import 'package:price_action_orders/presentation/widgets/limitbuy_form_field_price.dart';
import 'package:price_action_orders/presentation/widgets/limitbuy_form_field_total.dart';

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

  _setCurrentPrice() {
    final bookTickerState = BlocProvider.of<BookTickerBloc>(context).state;
    if (bookTickerState is LoadedBookTicker) {
      final currentPrice = (bookTickerState.bookTicker.bidPrice + bookTickerState.bookTicker.askPrice) / Decimal.fromInt(2);
      _priceController.text = currentPrice.toString();
    } else
      return;
  }

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
          PriceFormField(
            quoteAsset: widget.quoteAsset,
            priceController: _priceController,
            amountController: _amountController,
            totalController: _totalController,
            focusNext: () => FocusScope.of(context).requestFocus(_amountFocus),
            submitForm: _onFormSubmitted,
          ),
          SizedBox(height: 10),
          AmountFormField(
            baseAsset: widget.baseAsset,
            amountFocus: _amountFocus,
            priceController: _priceController,
            amountController: _amountController,
            totalController: _totalController,
            setCurrentPrice: _setCurrentPrice,
            submitForm: _onFormSubmitted,
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          TotalFormField(
            quoteAsset: widget.quoteAsset,
            priceController: _priceController,
            amountController: _amountController,
            totalController: _totalController,
            setCurrentPrice: _setCurrentPrice,
            submitForm: _onFormSubmitted,
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
