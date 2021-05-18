import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:intl/intl.dart';

class OpenOrdersWall extends StatefulWidget {
  @override
  _OpenOrdersWallState createState() => _OpenOrdersWallState();
}

class _OpenOrdersWallState extends State<OpenOrdersWall> {
  final _scrollController = ScrollController();

  void _cancelOrder(String symbol, int orderId) {
    final orderRequestNotifier = context.read(orderRequestNotifierProvider.notifier);

    final cancelOrderRequest = CancelOrderRequest(symbol: symbol, orderId: orderId);

    orderRequestNotifier.postCancelOrder(cancelOrderRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final ordersState = watch(ordersNotifierProvider);

        if (ordersState is OrdersLoaded) {
          return Column(
            children: [
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WallTableCell(label: 'Date', isHeader: true),
                  WallTableCell(label: 'Pair', isHeader: true),
                  WallTableCell(label: 'Type', isHeader: true),
                  WallTableCell(label: 'Side', isHeader: true),
                  WallTableCell(label: 'Price', isHeader: true),
                  WallTableCell(label: 'Amount', isHeader: true),
                  WallTableCell(label: 'Filled', isHeader: true),
                  WallTableCell(label: 'Total', isHeader: true),
                  WallTableCell(label: 'Action', isHeader: true),
                ],
              ),
              SizedBox(height: 5),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: ordersState.openOrders.length,
                    itemBuilder: (context, index) {
                      final dateTime = DateTime.fromMicrosecondsSinceEpoch(ordersState.openOrders[index].time);
                      final side = ordersState.openOrders[index].side.capitalize();
                      final filledQty = ordersState.openOrders[index].executedQty / ordersState.openOrders[index].origQty * Decimal.parse('100');
                      final total = ordersState.openOrders[index].price * ordersState.openOrders[index].origQty;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          WallTableCell(
                              label: DateFormat('y-MM-d H:m').format(dateTime), style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                          WallTableCell(label: ordersState.openOrders[index].symbol),
                          WallTableCell(label: ordersState.openOrders[index].type.capitalize()),
                          WallTableCell(label: side, style: TextStyle(color: side == 'Buy' ? Colors.green : Colors.red, fontWeight: FontWeight.w500)),
                          WallTableCell(label: ordersState.openOrders[index].price.toString()),
                          WallTableCell(label: ordersState.openOrders[index].origQty.toString()),
                          WallTableCell(label: filledQty.toStringAsFixed(2) + '%'),
                          WallTableCell(label: total.toString()),
                          WallTableCell(
                            child: TextButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Colors.indigo.shade400;
                                  }
                                  return Colors.indigo.shade300;
                                }),
                                overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                              ),
                              onPressed: () => _cancelOrder(ordersState.openOrders[index].symbol, ordersState.openOrders[index].orderId),
                              child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          );
        }
        return SizedBox();
      },
    );

    // final ordersState = watch(ordersNotifierProvider);

    // if (ordersState is OrdersLoaded) {
    //   return Column(
    //     children: [
    //       SizedBox(height: 5),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           WallTableCell(label: 'Date', isHeader: true),
    //           WallTableCell(label: 'Pair', isHeader: true),
    //           WallTableCell(label: 'Type', isHeader: true),
    //           WallTableCell(label: 'Side', isHeader: true),
    //           WallTableCell(label: 'Price', isHeader: true),
    //           WallTableCell(label: 'Amount', isHeader: true),
    //           WallTableCell(label: 'Filled', isHeader: true),
    //           WallTableCell(label: 'Total', isHeader: true),
    //           WallTableCell(label: 'Action', isHeader: true),
    //         ],
    //       ),
    //       SizedBox(height: 5),
    //       Expanded(
    //         child: Scrollbar(
    //           controller: _scrollController,
    //           isAlwaysShown: true,
    //           child: ListView.builder(
    //             controller: _scrollController,
    //             itemCount: ordersState.openOrders.length,
    //             itemBuilder: (context, index) {
    //               final dateTime = DateTime.fromMicrosecondsSinceEpoch(ordersState.openOrders[index].time);
    //               final side = ordersState.openOrders[index].side.capitalize();
    //               final filledQty = ordersState.openOrders[index].executedQty / ordersState.openOrders[index].origQty * Decimal.parse('100');
    //               final total = ordersState.openOrders[index].price * ordersState.openOrders[index].origQty;

    //               return Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   WallTableCell(
    //                       label: DateFormat('y-MM-d H:m').format(dateTime), style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
    //                   WallTableCell(label: ordersState.openOrders[index].symbol),
    //                   WallTableCell(label: ordersState.openOrders[index].type.capitalize()),
    //                   WallTableCell(label: side, style: TextStyle(color: side == 'Buy' ? Colors.green : Colors.red, fontWeight: FontWeight.w500)),
    //                   WallTableCell(label: ordersState.openOrders[index].price.toString()),
    //                   WallTableCell(label: ordersState.openOrders[index].origQty.toString()),
    //                   WallTableCell(label: filledQty.toStringAsFixed(2) + '%'),
    //                   WallTableCell(label: total.toString()),
    //                   WallTableCell(
    //                     child: TextButton(
    //                       style: ButtonStyle(
    //                         foregroundColor: MaterialStateProperty.resolveWith((states) {
    //                           if (states.contains(MaterialState.hovered)) {
    //                             return Colors.indigo.shade400;
    //                           }
    //                           return Colors.indigo.shade300;
    //                         }),
    //                         overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
    //                       ),
    //                       onPressed: () => _cancelOrder(ordersState.openOrders[index].symbol, ordersState.openOrders[index].orderId),
    //                       child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
    //                     ),
    //                   ),
    //                 ],
    //               );
    //             },
    //           ),
    //         ),
    //       )
    //     ],
    //   );
    // }
    // return SizedBox();
  }
}

class WallTableCell extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isHeader;
  final TextStyle style;
  final TextStyle greyStyle = TextStyle(color: Colors.white54, fontWeight: FontWeight.normal);
  final TextStyle whiteStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500);

  WallTableCell({Key key, this.label, this.child, this.isHeader = false, this.style})
      : assert((label != null || child != null) && !(label != null && child != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.pink,
      width: 100,
      child: child == null
          ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: isHeader ? greyStyle : style ?? whiteStyle,
              ),
            )
          : child,
    );
  }
}
