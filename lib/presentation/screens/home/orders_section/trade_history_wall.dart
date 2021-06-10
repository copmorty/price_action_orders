import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/presentation/shared/widgets/reload_widget.dart';
import 'widgets/wall_table_cell.dart';

class TradeHistoryWall extends StatefulWidget {
  @override
  _TradeHistoryWallState createState() => _TradeHistoryWallState();
}

class _TradeHistoryWallState extends State<TradeHistoryWall> {
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
            WallTableCell(label: 'Side', isHeader: true),
            WallTableCell(label: 'Price', isHeader: true),
            WallTableCell(label: 'Executed', isHeader: true),
            WallTableCell(label: 'Fee', isHeader: true),
            WallTableCell(label: 'Total', isHeader: true),
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
                if (ordersState.tradeHistory?.length == 0) {
                  return Center(
                    child: Text('You have no trades.', style: TextStyle(color: greyColor)),
                  );
                } else {
                  return Scrollbar(
                    controller: _scrollController,
                    isAlwaysShown: true,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: ordersState.tradeHistory.length,
                      itemBuilder: (context, index) {
                        final trade = ordersState.tradeHistory[index];
                        final dateTime = new DateTime.fromMillisecondsSinceEpoch(trade.time);
                        final fee = trade.commisionAmount.toString() + ' ' + trade.commisionAsset;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              WallTableCell(
                                label: DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime),
                                style: TextStyle(fontSize: CELL_FONT_SIZE, color: whiteColorOp70, fontWeight: CELL_FONT_WEIGHT_LIGHT),
                              ),
                              WallTableCell(label: trade.symbol),
                              WallTableCell(
                                label: trade.side.capitalize(),
                                style: TextStyle(
                                  fontSize: CELL_FONT_SIZE,
                                  color: trade.side == BinanceOrderSide.BUY ? buyColor : sellColor,
                                  fontWeight: CELL_FONT_WEIGHT,
                                ),
                              ),
                              WallTableCell(label: trade.price.toString()),
                              WallTableCell(label: trade.executedQty.toString()),
                              WallTableCell(label: fee),
                              WallTableCell(label: trade.quoteQty.toString()),
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
