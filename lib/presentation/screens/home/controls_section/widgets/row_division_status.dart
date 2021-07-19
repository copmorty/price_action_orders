import 'package:flutter/material.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'row_division.dart';

class RowDivisionStatus extends StatelessWidget {
  final BinanceOrderStatus status;
  final BinanceOrderSide side;

  const RowDivisionStatus(this.status, this.side, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == BinanceOrderStatus.FILLED) {
      return Row(
        children: [
          Expanded(child: Text('STATUS:', textAlign: TextAlign.right)),
          SizedBox(width: 5),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: side == BinanceOrderSide.BUY ? buyColor : sellColor,
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  child: Text(status.capitalizeCharacters(), style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return RowDivision('STATUS:', status.capitalizeCharacters());
    }
  }
}
