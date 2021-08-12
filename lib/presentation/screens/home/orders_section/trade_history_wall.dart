import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/domain/entities/trade.dart';
import 'package:price_action_orders/presentation/screens/home/orders_section/widgets/wall_table.dart';
import 'package:price_action_orders/presentation/screens/home/orders_section/widgets/wall_table_empty.dart';
import 'package:price_action_orders/presentation/screens/home/orders_section/widgets/wall_table_row.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/presentation/shared/widgets/reload_widget.dart';
import 'widgets/wall_table_cell.dart';

class TradeHistoryWall extends StatelessWidget {
  const TradeHistoryWall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WallTable(
      headerCells: [
        WallTableCell(label: 'Date', isHeader: true),
        WallTableCell(label: 'Pair', isHeader: true),
        WallTableCell(label: 'Side', isHeader: true),
        WallTableCell(label: 'Price', isHeader: true),
        WallTableCell(label: 'Executed', isHeader: true),
        WallTableCell(label: 'Fee', isHeader: true),
        WallTableCell(label: 'Total', isHeader: true),
      ],
      content: Consumer(
        builder: (context, watch, child) {
          final ordersState = watch(ordersNotifierProvider);

          if (ordersState is OrdersLoading) return LoadingWidget();

          if (ordersState is OrdersError) {
            return ReloadWidget(context.read(stateHandlerProvider).reloadOrderLists);
          }

          if (ordersState is OrdersLoaded) {
            if (ordersState.tradeHistory?.length == 0)
              return WallTableEmpty('You have no trades.');
            else
              return _WallData(ordersState.tradeHistory);
          }

          return SizedBox();
        },
      ),
    );
  }
}

class _WallData extends StatefulWidget {
  final List<Trade> tradeHistory;

  const _WallData(this.tradeHistory, {Key? key}) : super(key: key);

  @override
  __WallDataState createState() => __WallDataState();
}

class __WallDataState extends State<_WallData> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      isAlwaysShown: true,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.tradeHistory.length,
        itemBuilder: (context, index) {
          final trade = widget.tradeHistory[index];
          final dateTime = new DateTime.fromMillisecondsSinceEpoch(trade.time);
          final fee = trade.commisionAmount.toString() + ' ' + trade.commisionAsset;

          return WallTableRow(
            cells: [
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
          );
        },
      ),
    );
  }
}
