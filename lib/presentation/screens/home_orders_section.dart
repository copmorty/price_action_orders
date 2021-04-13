import 'package:flutter/material.dart';

class OrdersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              OrderTypeBtn(orderType: 'Limit'),
              OrderTypeBtn(orderType: 'Market'),
              OrderTypeBtn(orderType: 'Stop-limit'),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderTypeBtn extends StatelessWidget {
  final String orderType;

  const OrderTypeBtn({Key key, @required this.orderType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: orderType == 'Market'
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.white),
              ),
            )
          : null,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Text(
        orderType,
        style: TextStyle(color: orderType == 'Market' ? Colors.white : Colors.grey),
      ),
    );
  }
}
