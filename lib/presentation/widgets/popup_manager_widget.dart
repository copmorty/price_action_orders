import 'dart:async';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/presentation/logic/order_state_notifier.dart';
import 'package:price_action_orders/providers.dart';

/// This is basically an empty UI widget that only
/// manages popup messages
class PopupManager extends StatefulWidget {
  @override
  _PopupManagerState createState() => _PopupManagerState();
}

class _PopupManagerState extends State<PopupManager> {
  Timer _timer;

  @override
  Widget build(BuildContext buildContext) {
    return ProviderListener(
      onChange: (context, state) {
        if (state is OrderError) {
          showOrderErrorDialog(state.message);
        }
        if (state is MarketOrderLoaded) {
          showOrderLoadedDialog(state.orderResponse);
        }
        if (state is LimitOrderLoaded) {
          showOrderLoadedDialog(state.orderResponse);
        }
      },
      provider: orderNotifierProvider,
      child: SizedBox(),
    );
  }

  void showOrderErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 2, color: Colors.transparent),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, size: 100),
                SizedBox(height: 20),
                Text('ERROR', textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
              ],
            ),
          ),
        );
      },
    );
  }

  void showOrderLoadedDialog(OrderResponseFull orderResponse) {
    final bool orderCompleted = orderResponse.status == BinanceOrderStatus.FILLED;

    showDialog(
      // barrierDismissible: orderCompleted ? false : true,
      context: context,
      builder: (context) {
        if (orderCompleted) {
          // _timer = Timer(Duration(seconds: 4), () {
          //   Navigator.of(context).pop();
          // });
        }
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            width: MediaQuery.of(context).size.width / 3,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: 2,
                color: orderCompleted
                    ? orderResponse.side == BinanceOrderSide.BUY
                        ? Colors.green
                        : Colors.red
                    : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(orderResponse.symbol, textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 25),
                    children: [
                      TextSpan(text: orderResponse.type.toShortString()),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: orderResponse.side.toShortString(),
                        style: TextStyle(color: orderResponse.side == BinanceOrderSide.BUY ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                ),
                orderResponse.type == BinanceOrderType.LIMIT ? LimitOrderPopupDialog(orderResponse) : MarketOrderPopupDialog(orderResponse),
              ],
            ),
          ),
        );
      },
    ).then(
      (_) {
        if (_timer?.isActive ?? false) {
          _timer.cancel();
        }
      },
    );
  }
}

class LimitOrderPopupDialog extends StatelessWidget {
  final OrderResponseFull orderResponse;

  LimitOrderPopupDialog(this.orderResponse);

  @override
  Widget build(BuildContext context) {
    Decimal weightedAveragePrice;
    if (orderResponse.executedQty > Decimal.zero) {
      final sum = orderResponse.fills.fold(Decimal.zero, (prev, el) => prev + el.price * el.quantity);
      weightedAveragePrice = sum / orderResponse.executedQty;
    }

    return Column(
      children: [
        RowDivision('STATUS:', orderResponse.status.toShortString()),
        if (orderResponse.side == BinanceOrderSide.BUY) ...[
          RowDivision('LIMIT PRICE:', orderResponse.price.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('TO BUY:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('TO SPENT:', (orderResponse.price * orderResponse.origQty).toString() + ' ' + orderResponse.ticker.quoteAsset),
          if (weightedAveragePrice != null) ...[
            Divider(),
            RowDivision('PRICE:', weightedAveragePrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
            RowDivision('BOUGHT:', orderResponse.executedQty.toString() + ' ' + orderResponse.ticker.baseAsset),
            RowDivision('SPENT:', orderResponse.cummulativeQuoteQty.toString() + ' ' + orderResponse.ticker.quoteAsset),
          ],
        ],
        if (orderResponse.side == BinanceOrderSide.SELL) ...[
          RowDivision('LIMIT PRICE:', orderResponse.price.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('TO SELL:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('TO RECEIVE:', (orderResponse.price * orderResponse.origQty).toString() + ' ' + orderResponse.ticker.quoteAsset),
          if (weightedAveragePrice != null) ...[
            Divider(),
            RowDivision('PRICE:', weightedAveragePrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
            RowDivision('SOLD:', orderResponse.executedQty.toString() + ' ' + orderResponse.ticker.baseAsset),
            RowDivision('RECEIVED:', orderResponse.cummulativeQuoteQty.toString() + ' ' + orderResponse.ticker.quoteAsset),
          ],
        ],
      ],
    );
  }
}

class MarketOrderPopupDialog extends StatelessWidget {
  final OrderResponseFull orderResponse;

  MarketOrderPopupDialog(this.orderResponse);

  @override
  Widget build(BuildContext context) {
    Decimal weightedAveragePrice;
    if (orderResponse.executedQty > Decimal.zero) {
      final sum = orderResponse.fills.fold(Decimal.zero, (prev, el) => prev + el.price * el.quantity);
      weightedAveragePrice = sum / orderResponse.executedQty;
    }

    return Column(
      children: [
        RowDivision('STATUS:', orderResponse.status.toShortString()),
        if (weightedAveragePrice != null && orderResponse.side == BinanceOrderSide.BUY) ...[
          orderResponse.origQty != orderResponse.executedQty
              ? RowDivision('TRIED TO BUY:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset)
              : SizedBox(),
          RowDivision('BOUGHT:', orderResponse.executedQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('PRICE:', weightedAveragePrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('SPENT:', orderResponse.cummulativeQuoteQty.toString() + ' ' + orderResponse.ticker.quoteAsset),
        ],
        if (weightedAveragePrice != null && orderResponse.side == BinanceOrderSide.SELL) ...[
          orderResponse.origQty != orderResponse.executedQty
              ? RowDivision('TRIED TO SELL:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset)
              : SizedBox(),
          RowDivision('SOLD:', orderResponse.executedQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('PRICE:', weightedAveragePrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('RECEIVED:', orderResponse.cummulativeQuoteQty.toString() + ' ' + orderResponse.ticker.quoteAsset),
        ],
      ],
    );
  }
}

class RowDivision extends StatelessWidget {
  final String leftText;
  final String rightText;

  const RowDivision(this.leftText, this.rightText, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(leftText, textAlign: TextAlign.right)),
        SizedBox(width: 5),
        Expanded(child: SelectableText(rightText, textAlign: TextAlign.left)),
      ],
    );
  }
}
