import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/presentation/logic/bookticker_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/trade_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'limit_form_field_amount.dart';
import 'limit_form_field_price.dart';
import 'limit_form_field_total.dart';

class LimitSellForm extends StatefulWidget {
  final String baseAsset;
  final String quoteAsset;

  const LimitSellForm({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  _LimitSellFormState createState() => _LimitSellFormState();
}

class _LimitSellFormState extends State<LimitSellForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final FocusNode _amountFocus = FocusNode();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  int operationId;

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
    _amountController.dispose();
    _totalController.dispose();
    _amountFocus.dispose();
  }

  _setCurrentPrice() {
    final bookTickerState = context.read(bookTickerNotifierProvider);
    if (bookTickerState is BookTickerLoaded) {
      final currentPrice = (bookTickerState.bookTicker.bidPrice + bookTickerState.bookTicker.askPrice) / Decimal.fromInt(2);
      _priceController.text = currentPrice.toString();
    } else
      return;
  }

  _onFormSubmitted() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final price = Decimal.parse(_priceController.text);
      final quantity = Decimal.parse(_amountController.text);

      final limitOrder = LimitOrderRequest(
        ticker: Ticker(baseAsset: widget.baseAsset, quoteAsset: widget.quoteAsset),
        side: BinanceOrderSide.SELL,
        timeInForce: BinanceOrderTimeInForce.GTC,
        quantity: quantity,
        price: price,
      );
      operationId = limitOrder.timestamp;

      _priceController.clear();
      _amountController.clear();
      _totalController.clear();
      FocusScope.of(context).unfocus();
      context.read(tradeNotifierProvider.notifier).postLimitOrder(limitOrder);
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
            child: Consumer(
              builder: (context, watch, child) {
                final tradeState = watch(tradeNotifierProvider);

                if (tradeState is TradeLoading && tradeState.operationId == operationId) {
                  return ElevatedButton(
                    onPressed: () {},
                    child: LoadingWidget(height: 20, width: 20, color: whiteColorOp70),
                    style: ElevatedButton.styleFrom(primary: sellColor),
                  );
                }

                return ElevatedButton(
                  onPressed: _onFormSubmitted,
                  child: Text(
                    'Sell ${widget.baseAsset}',
                    style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(primary: sellColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
