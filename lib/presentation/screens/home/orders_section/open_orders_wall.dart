import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/trade_state_notifier.dart';
import 'package:price_action_orders/presentation/widgets/loading_widget.dart';
import 'package:price_action_orders/presentation/widgets/reload_widget.dart';
import 'widgets/wall_table_cell.dart';

class OpenOrdersWall extends StatefulWidget {
  @override
  _OpenOrdersWallState createState() => _OpenOrdersWallState();
}

class _OpenOrdersWallState extends State<OpenOrdersWall> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            WallTableCell(label: 'Trigger Conditions', isHeader: true),
            WallTableCell(label: 'Action', isHeader: true),
          ],
        ),
        SizedBox(height: 5),
        Expanded(
          child: Consumer(
            builder: (context, watch, child) {
              final ordersState = watch(ordersNotifierProvider);
              if (ordersState is OrdersLoading) {
                return LoadingWidget();
              }
              if (ordersState is OrdersError) {
                return ReloadWidget(() {
                  context.read(userDataStream).initialization();
                  context.read(ordersNotifierProvider.notifier).getOpenOrders();
                });
              }
              if (ordersState is OrdersLoaded) {
                if (ordersState.openOrders.length == 0) {
                  return Center(
                    child: Text('You have no open orders.', style: TextStyle(color: Colors.white54)),
                  );
                } else {
                  return Scrollbar(
                    controller: _scrollController,
                    isAlwaysShown: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: ordersState.openOrders.length,
                      itemBuilder: (context, index) {
                        final order = ordersState.openOrders[index];
                        final dateTime = new DateTime.fromMillisecondsSinceEpoch(order.time);
                        final amount = order.origQty;
                        final filledQty = order.executedQty / order.origQty * Decimal.parse('100');
                        final total = order.price * order.origQty;
                        final triggerConditions = order.stopPrice == Decimal.zero ? '-' : '<= ' + order.stopPrice.toString();

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              WallTableCell(
                                label: DateFormat('MM-d HH:mm:ss').format(dateTime),
                                style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                              ),
                              WallTableCell(label: order.symbol),
                              WallTableCell(label: order.type.capitalizeWords()),
                              WallTableCell(
                                label: order.side.capitalize(),
                                style: TextStyle(color: order.side == BinanceOrderSide.BUY ? Colors.green : Colors.red, fontWeight: FontWeight.w500),
                              ),
                              WallTableCell(label: order.price.toString()),
                              WallTableCell(label: amount.toString()),
                              WallTableCell(label: filledQty.toStringAsFixed(2) + '%'),
                              WallTableCell(label: total.toString()),
                              WallTableCell(label: triggerConditions),
                              WallTableCell(
                                child: _CancelOrderButton(order),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              }

              return SizedBox();
            },
          ),
        ),
      ],
    );
  }
}

class _CancelOrderButton extends StatefulWidget {
  final Order order;

  const _CancelOrderButton(this.order, {Key key}) : super(key: key);

  @override
  __CancelOrderButtonState createState() => __CancelOrderButtonState();
}

class __CancelOrderButtonState extends State<_CancelOrderButton> {
  int operationId;

  void _cancelOrder() {
    final cancelOrderRequest = CancelOrderRequest(symbol: widget.order.symbol, orderId: widget.order.orderId);
    operationId = cancelOrderRequest.timestamp;
    context.read(tradeNotifierProvider.notifier).postCancelOrder(cancelOrderRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final tradeState = watch(tradeNotifierProvider);

      if (tradeState is TradeLoading && tradeState.operationId == operationId) {
        return LoadingWidget(height: 15, width: 15);
      }

      return TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(Size(0, 0)),
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) return Colors.indigo.shade400;
            return Colors.indigo.shade300;
          }),
        ),
        onPressed: _cancelOrder,
        child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
      );
    });
  }
}
