import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/presentation/logic/trade_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'widgets/popup_dialog_market.dart';
import 'widgets/popup_dialog_limit.dart';
import 'widgets/popup_dialog_stop_limit.dart';

/// This is an empty UI widget that manages popup messages
class PopupManager extends StatefulWidget {
  @override
  _PopupManagerState createState() => _PopupManagerState();
}

class _PopupManagerState extends State<PopupManager> {
  Timer? _timer;

  @override
  Widget build(BuildContext buildContext) {
    return ProviderListener(
      provider: tradeNotifierProvider,
      onChange: (context, TradeState state) {
        if (state is TradeError) _showOrderErrorDialog(state.message);
        if (state is TradeLoaded) _showOrderLoadedDialog(state.orderResponse);
      },
      child: SizedBox(),
    );
  }

  void _showOrderErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: blackColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(width: 2, color: transparentColor),
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

  void _showOrderLoadedDialog(OrderResponseFull orderResponse) {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        ? buyColor
                        : sellColor
                    : transparentColor,
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
                      TextSpan(text: orderResponse.type.capitalizeCharacters()),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: orderResponse.side.toShortString(),
                        style: TextStyle(color: orderResponse.side == BinanceOrderSide.BUY ? buyColor : sellColor),
                      ),
                    ],
                  ),
                ),
                if (orderResponse.type == BinanceOrderType.LIMIT) LimitOrderPopupDialog(orderResponse),
                if (orderResponse.type == BinanceOrderType.MARKET) MarketOrderPopupDialog(orderResponse),
                if (orderResponse.type == BinanceOrderType.STOP_LOSS_LIMIT) StopLimitOrderPopupDialog(orderResponse),
                if (orderResponse.type == BinanceOrderType.TAKE_PROFIT_LIMIT) StopLimitOrderPopupDialog(orderResponse),
              ],
            ),
          ),
        );
      },
    ).then(
      (_) {
        if (_timer?.isActive ?? false) {
          _timer!.cancel();
        }
      },
    );
  }
}
