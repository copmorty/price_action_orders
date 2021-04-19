import 'dart:async';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/presentation/bloc/order_bloc.dart';

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
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is ErrorOrder) {
          showOrderErrorDialog(state.message);
        }
        if (state is LoadedMarketOrder) {
          showOrderLoadedDialog(state.orderResponse);
        }
      },
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
    Decimal weightedAveragePrice;
    if (orderResponse.executedQty > Decimal.zero) {
      final sum = orderResponse.fills.fold(Decimal.zero, (prev, el) => prev + el.price * el.quantity);
      weightedAveragePrice = sum / orderResponse.executedQty;
    }

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
            width: MediaQuery.of(context).size.width/4,
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
                if (weightedAveragePrice != null) ...[
                  SelectableText('Executed Quantity: ' + orderResponse.executedQty.toString()),
                  SelectableText('Weighted Average Price: ' + weightedAveragePrice.toString()),
                ],
                Text('status: ' + orderResponse.status.toShortString()),
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
