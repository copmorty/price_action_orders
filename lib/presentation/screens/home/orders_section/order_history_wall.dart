import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart';
import 'package:price_action_orders/presentation/widgets/loading_widget.dart';
import 'widgets/wall_table_cell.dart';

class OrderHistoryWall extends StatefulWidget {
  @override
  _OrderHistoryWallState createState() => _OrderHistoryWallState();
}

class _OrderHistoryWallState extends State<OrderHistoryWall> {
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
            WallTableCell(label: 'Average', isHeader: true),
            WallTableCell(label: 'Price', isHeader: true),
            WallTableCell(label: 'Executed', isHeader: true),
            WallTableCell(label: 'Amount', isHeader: true),
            WallTableCell(label: 'Total', isHeader: true),
            WallTableCell(label: 'Trigger Conditions', isHeader: true),
            WallTableCell(label: 'Status', isHeader: true),
          ],
        ),
        SizedBox(height: 5),
        Consumer(
          builder: (context, watch, child) {
            final ordersState = watch(ordersNotifierProvider);
            if (ordersState is OrdersLoading) {
              return Expanded(
                child: LoadingWidget(),
              );
            }
            if (ordersState is OrdersLoaded) {
              return Expanded(
                child: ordersState.orderHistory?.length == 0
                    ? Center(
                        child: Text('You have no order history.', style: TextStyle(color: Colors.white54)),
                      )
                    : Scrollbar(
                        controller: _scrollController,
                        isAlwaysShown: true,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: ordersState.orderHistory.length,
                          itemBuilder: (context, index) {
                            final order = ordersState.orderHistory[index];
                            final dateTime = new DateTime.fromMillisecondsSinceEpoch(order.time);
                            final average = order.executedQty == Decimal.zero ? '-' : (order.cummulativeQuoteQty / order.executedQty).toString();
                            final price = order.type == BinanceOrderType.MARKET ? order.type.capitalizeWords() : order.price.toString();
                            final executed = order.executedQty == Decimal.zero ? '-' : order.executedQty.toString();
                            final amount = order.origQty;
                            final total = order.cummulativeQuoteQty == Decimal.zero ? '-' : order.cummulativeQuoteQty.toString();
                            final triggerConditions = order.stopPrice == Decimal.zero ? '-' : '<= ' + order.stopPrice.toString();

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.5),
                              child: Opacity(
                                opacity: order.status == BinanceOrderStatus.CANCELED ? 0.4 : 1,
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
                                      style: TextStyle(
                                          color: order.side == BinanceOrderSide.BUY ? Colors.green : Colors.red, fontWeight: FontWeight.w500),
                                    ),
                                    WallTableCell(label: average.toString()),
                                    WallTableCell(label: price),
                                    WallTableCell(label: executed),
                                    WallTableCell(label: amount.toString()),
                                    WallTableCell(label: total.toString()),
                                    WallTableCell(label: triggerConditions),
                                    WallTableCell(label: order.status.capitalizeWords()),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              );
            }

            return SizedBox();
          },
        ),
      ],
    );
  }
}
