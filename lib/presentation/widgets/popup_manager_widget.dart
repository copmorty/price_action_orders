import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/core/globals/enums.dart';
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
        if (state is LoadedMarketOrder) {
          final bool orderCompleted = state.orderResponse.status == BinanceOrderStatus.FILLED;
          showDialog(
            barrierDismissible: orderCompleted ? false : true,
            context: context,
            builder: (context) {
              if (orderCompleted) {
                _timer = Timer(Duration(seconds: 5), () {
                  Navigator.of(context).pop();
                });
              }
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                contentPadding: const EdgeInsets.all(0),
                content: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      width: 2,
                      color: orderCompleted
                          ? state.orderResponse.side == BinanceOrderSide.BUY
                              ? Colors.green
                              : Colors.red
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.orderResponse.symbol, textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
                      SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 25),
                          children: [
                            TextSpan(text: state.orderResponse.type.toShortString()),
                            TextSpan(text: ' '),
                            TextSpan(
                              text: state.orderResponse.side.toShortString(),
                              style: TextStyle(color: state.orderResponse.side == BinanceOrderSide.BUY ? Colors.green : Colors.red),
                            ),
                          ],
                        ),
                      ),
                      // Text('price: ' + state.orderResponse.price),
                      Text('status: ' + state.orderResponse.status.toShortString()),
                    ],
                  ),
                ),
              );
            },
          ).then(
            (_) {
              if (_timer.isActive) {
                _timer.cancel();
              }
            },
          );
        }
      },
      child: SizedBox(),
    );
  }
}
