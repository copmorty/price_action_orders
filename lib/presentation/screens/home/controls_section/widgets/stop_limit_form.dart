import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_stop_limit.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/presentation/logic/bookticker_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/trade_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'form_field_amount.dart';
import 'form_field_price.dart';
import 'form_field_stop.dart';
import 'form_field_total.dart';

class StopLimitForm extends StatefulWidget {
  final AppOrderType appOrderType;
  // final BinanceOrderType binanceOrderType;
  final BinanceOrderSide binanceOrderSide;
  final String baseAsset;
  final String quoteAsset;

  const StopLimitForm({
    Key? key,
    required this.appOrderType,
    // required this.binanceOrderType,
    required this.binanceOrderSide,
    required this.baseAsset,
    required this.quoteAsset,
  }) : super(key: key);

  @override
  _StopLimitFormState createState() => _StopLimitFormState();
}

class _StopLimitFormState extends State<StopLimitForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _stopPriceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final FocusNode _priceFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  int? operationId;

  @override
  void dispose() {
    super.dispose();
    _stopPriceController.dispose();
    _priceController.dispose();
    _amountController.dispose();
    _totalController.dispose();
    _priceFocus.dispose();
    _amountFocus.dispose();
  }

  void _onFormSubmitted() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final stopPrice = Decimal.tryParse(_stopPriceController.text);
      final price = Decimal.parse(_priceController.text);
      final quantity = Decimal.parse(_amountController.text);

      switch (widget.appOrderType) {
        case AppOrderType.LIMIT:
          final limitOrder = LimitOrderRequest(
            ticker: Ticker(baseAsset: widget.baseAsset, quoteAsset: widget.quoteAsset),
            side: widget.binanceOrderSide,
            timeInForce: BinanceOrderTimeInForce.GTC,
            quantity: quantity,
            price: price,
          );
          operationId = limitOrder.timestamp;
          context.read(tradeNotifierProvider.notifier).postOrder(limitOrder);
          break;

        case AppOrderType.STOP_LIMIT:
          final bookTickerState = context.read(bookTickerNotifierProvider);

          if (bookTickerState is BookTickerLoaded) {
            final currentPrice = widget.binanceOrderSide == BinanceOrderSide.BUY ? bookTickerState.bookTicker.bidPrice : bookTickerState.bookTicker.askPrice;

            final stopLimitOrder = StopLimitOrderRequest(
              ticker: Ticker(baseAsset: widget.baseAsset, quoteAsset: widget.quoteAsset),
              side: widget.binanceOrderSide,
              currentMarketPrice: currentPrice,
              timeInForce: BinanceOrderTimeInForce.GTC,
              quantity: quantity,
              price: price,
              stopPrice: stopPrice!,
            );

            operationId = stopLimitOrder.timestamp;

            context.read(tradeNotifierProvider.notifier).postOrder(stopLimitOrder);
          } else
            throw Error();
          break;

        default:
      }

      _stopPriceController.clear();
      _priceController.clear();
      _amountController.clear();
      _totalController.clear();
      FocusScope.of(context).unfocus();

      setState(() {
        _autovalidateMode = AutovalidateMode.disabled;
      });
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  void _setCurrentPrice() {
    final bookTickerState = context.read(bookTickerNotifierProvider);
    if (bookTickerState is BookTickerLoaded) {
      final currentPrice = (bookTickerState.bookTicker.bidPrice + bookTickerState.bookTicker.askPrice) / Decimal.fromInt(2);
      _priceController.text = currentPrice.toString();
    } else
      return;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        children: [
          if (widget.appOrderType == AppOrderType.STOP_LIMIT) ...[
            StopPriceFormField(
              quoteAsset: widget.quoteAsset,
              controller: _stopPriceController,
              priceController: _priceController,
              amountController: _amountController,
              totalController: _totalController,
              focusNext: () => FocusScope.of(context).requestFocus(_priceFocus),
              submitForm: _onFormSubmitted,
            ),
            SizedBox(height: 10),
          ],
          PriceFormField(
            hintText: widget.appOrderType == AppOrderType.STOP_LIMIT ? 'Limit' : 'Price',
            quoteAsset: widget.quoteAsset,
            controller: _priceController,
            focusNode: _priceFocus,
            amountController: _amountController,
            totalController: _totalController,
            focusNext: () => FocusScope.of(context).requestFocus(_amountFocus),
            submitForm: _onFormSubmitted,
          ),
          SizedBox(height: 10),
          AmountFormField(
            baseAsset: widget.baseAsset,
            focusNode: _amountFocus,
            priceController: _priceController,
            controller: _amountController,
            totalController: _totalController,
            setCurrentPrice: _setCurrentPrice,
            submitForm: _onFormSubmitted,
          ),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          TotalFormField(
            quoteAsset: widget.quoteAsset,
            controller: _totalController,
            priceController: _priceController,
            amountController: _amountController,
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
                    style: ElevatedButton.styleFrom(primary: widget.binanceOrderSide == BinanceOrderSide.BUY ? buyColor : sellColor),
                  );
                }

                return ElevatedButton(
                  onPressed: _onFormSubmitted,
                  child: Text(
                    '${widget.binanceOrderSide == BinanceOrderSide.BUY ? 'Buy' : 'Sell'}  ${widget.baseAsset}',
                    style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(primary: widget.binanceOrderSide == BinanceOrderSide.BUY ? buyColor : sellColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
