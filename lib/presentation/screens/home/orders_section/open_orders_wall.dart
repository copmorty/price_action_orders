import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/presentation/screens/home/orders_section/widgets/wall_table.dart';
import 'package:price_action_orders/presentation/screens/home/orders_section/widgets/wall_table_empty.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/trade_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/presentation/shared/widgets/reload_widget.dart';
import 'widgets/wall_table_cell.dart';
import 'widgets/wall_table_row.dart';

class OpenOrdersWall extends StatelessWidget {
  const OpenOrdersWall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WallTable(
      headerCells: [
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
      content: Consumer(
        builder: (context, watch, child) {
          final ordersState = watch(ordersNotifierProvider);

          if (ordersState is OrdersLoading) return LoadingWidget();

          if (ordersState is OrdersError) {
            return ReloadWidget(context.read(stateHandlerProvider).reloadOrderLists);
          }

          if (ordersState is OrdersLoaded) {
            if (ordersState.openOrders.length == 0)
              return WallTableEmpty('You have no open orders.');
            else
              return _WallData(ordersState.openOrders);
          }

          return SizedBox();
        },
      ),
    );
  }
}

class _WallData extends StatefulWidget {
  final List<Order> openOrders;

  const _WallData(this.openOrders, {Key? key}) : super(key: key);

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
        itemCount: widget.openOrders.length,
        itemBuilder: (context, index) {
          final order = widget.openOrders[index];
          final dateTime = new DateTime.fromMillisecondsSinceEpoch(order.time);
          final amount = order.origQty;
          final filledQty = order.executedQty / order.origQty * Decimal.parse('100');
          final total = order.price * order.origQty;
          String triggerConditions = '-';

          if (order.type == BinanceOrderType.TAKE_PROFIT_LIMIT) {
            final symbol = order.side == BinanceOrderSide.BUY ? '<= ' : '>= ';
            triggerConditions = symbol + order.stopPrice.toString();
          }
          if (order.type == BinanceOrderType.STOP_LOSS_LIMIT) {
            final symbol = order.side == BinanceOrderSide.BUY ? '>= ' : '<= ';
            triggerConditions = symbol + order.stopPrice.toString();
          }

          return WallTableRow(
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
              WallTableCell(label: order.price.toString()),
              WallTableCell(label: amount.toString()),
              WallTableCell(label: filledQty.toStringAsFixed(2) + '%'),
              WallTableCell(label: total.toString()),
              WallTableCell(label: triggerConditions),
              WallTableCell(
                child: _CancelOrderButton(key: ValueKey(order.orderId), order: order),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CancelOrderButton extends StatefulWidget {
  final Order order;

  const _CancelOrderButton({
    required Key key,
    required this.order,
  }) : super(key: key);

  @override
  __CancelOrderButtonState createState() => __CancelOrderButtonState();
}

class __CancelOrderButtonState extends State<_CancelOrderButton> {
  int? operationId;

  void _cancelOrder() {
    final cancelOrderRequest = CancelOrderRequest(symbol: widget.order.symbol, orderId: widget.order.orderId);
    operationId = cancelOrderRequest.timestamp;
    context.read(tradeNotifierProvider.notifier).cancelOrder(cancelOrderRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final tradeState = watch(tradeNotifierProvider);

      if (tradeState is TradeLoading && tradeState.operationId == operationId) {
        return LoadingWidget(height: CELL_FONT_SIZE, width: CELL_FONT_SIZE);
      }

      return TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          minimumSize: MaterialStateProperty.all(Size(0, 0)),
          overlayColor: MaterialStateColor.resolveWith((states) => transparentColor),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) return mainColorDark;
            return mainColor;
          }),
        ),
        onPressed: _cancelOrder,
        child: Text('Cancel', style: TextStyle(fontSize: CELL_FONT_SIZE, fontWeight: CELL_FONT_WEIGHT)),
      );
    });
  }
}
