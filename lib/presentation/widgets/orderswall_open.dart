import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:intl/intl.dart';

class OpenOrdersWall extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ordersState = watch(ordersNotifierProvider);

    if (ordersState is OrdersLoaded) {
      return Column(
        children: [
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              WallTableCell('Date', isHeader: true),
              WallTableCell('Pair', isHeader: true),
              WallTableCell('Type', isHeader: true),
              WallTableCell('Side', isHeader: true),
              WallTableCell('Price', isHeader: true),
              WallTableCell('Amount', isHeader: true),
              WallTableCell('Filled', isHeader: true),
              WallTableCell('Total', isHeader: true),
              WallTableCell('Action', isHeader: true),
            ],
          ),
          SizedBox(height: 5),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              child: ListView.builder(
                itemCount: ordersState.openOrders.length,
                itemBuilder: (context, index) {
                  final filledQty = ordersState.openOrders[index].executedQty / ordersState.openOrders[index].origQty * Decimal.parse('100');
                  final total = ordersState.openOrders[index].price * ordersState.openOrders[index].origQty;
                  final dateTime = DateTime.fromMicrosecondsSinceEpoch(ordersState.openOrders[index].time);
                  final side = ordersState.openOrders[index].side.capitalize();

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      WallTableCell(DateFormat('y-MM-d H:m').format(dateTime), style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                      WallTableCell(ordersState.openOrders[index].symbol),
                      WallTableCell(ordersState.openOrders[index].type.capitalize()),
                      WallTableCell(side, style: TextStyle(color: side == 'Buy' ? Colors.green : Colors.red, fontWeight: FontWeight.w500)),
                      WallTableCell(ordersState.openOrders[index].price.toString()),
                      WallTableCell(ordersState.openOrders[index].origQty.toString()),
                      WallTableCell(filledQty.toStringAsFixed(2) + '%'),
                      WallTableCell(total.toString()),
                      WallTableCell('-'),
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
  }
}

class WallTableCell extends StatelessWidget {
  final String label;
  final bool isHeader;
  final TextStyle style;
  final TextStyle greyStyle = TextStyle(color: Colors.white54, fontWeight: FontWeight.normal);
  final TextStyle whiteStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500);

  WallTableCell(this.label, {Key key, this.isHeader = false, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.pink,
      width: 100,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: isHeader ? greyStyle : style ?? whiteStyle,
        ),
      ),
    );
  }
}
