import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/domain/entities/order.dart';
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

class OrderHistoryWall extends StatelessWidget {
  const OrderHistoryWall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WallTable(
      headerCells: [
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
      content: Consumer(
        builder: (context, watch, child) {
          final ordersState = watch(ordersNotifierProvider);

          if (ordersState is OrdersLoading) return LoadingWidget();

          if (ordersState is OrdersError) {
            return ReloadWidget(context.read(stateHandlerProvider).reloadOrderLists);
          }

          if (ordersState is OrdersLoaded) {
            if (ordersState.orderHistory?.length == 0)
              return WallTableEmpty('You have no order history.');
            else
              return _WallData(ordersState.orderHistory);
          }

          return SizedBox();
        },
      ),
    );
  }
}

class _WallData extends StatefulWidget {
  final List<Order> orderHistory;

  const _WallData(this.orderHistory, {Key? key}) : super(key: key);

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
        itemCount: widget.orderHistory.length,
        itemBuilder: (context, index) {
          final order = widget.orderHistory[index];
          final dateTime = new DateTime.fromMillisecondsSinceEpoch(order.time);
          final average = order.executedQty == Decimal.zero ? '-' : (order.cummulativeQuoteQty / order.executedQty).toString();
          final price = order.type == BinanceOrderType.MARKET ? order.type.capitalizeWords() : order.price.toString();
          final executed = order.executedQty == Decimal.zero ? '-' : order.executedQty.toString();
          final amount = order.origQty;
          final total = order.cummulativeQuoteQty == Decimal.zero ? '-' : order.cummulativeQuoteQty.toString();
          final triggerConditions = order.stopPrice == Decimal.zero ? '-' : '<= ' + order.stopPrice.toString();

          return WallTableRow(
            opacity: order.status == BinanceOrderStatus.CANCELED ? 0.4 : 1,
            cells: [
              WallTableCell(
                label: DateFormat('MM-dd HH:mm:ss').format(dateTime),
                style: TextStyle(fontSize: CELL_FONT_SIZE, fontWeight: CELL_FONT_WEIGHT_LIGHT, color: whiteColorOp70),
              ),
              WallTableCell(label: order.symbol),
              WallTableCell(label: order.type.capitalizeWords()),
              WallTableCell(
                label: order.side.capitalize(),
                style: TextStyle(
                  fontSize: CELL_FONT_SIZE,
                  fontWeight: CELL_FONT_WEIGHT,
                  color: order.side == BinanceOrderSide.BUY ? buyColor : sellColor,
                ),
              ),
              WallTableCell(label: average.toString()),
              WallTableCell(label: price),
              WallTableCell(label: executed),
              WallTableCell(label: amount.toString()),
              WallTableCell(label: total.toString()),
              WallTableCell(label: triggerConditions),
              WallTableCell(label: order.status.capitalizeWords()),
            ],
          );
        },
      ),
    );
  }
}
