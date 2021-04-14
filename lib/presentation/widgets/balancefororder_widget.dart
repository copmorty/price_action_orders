import 'package:flutter/material.dart';
import 'package:price_action_orders/domain/entities/balance.dart';

class BalanceForOrder extends StatelessWidget {
  final List<Balance> balances;
  final String asset;

  const BalanceForOrder({Key key, @required this.balances, @required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balance = balances.firstWhere((element) => element.asset == asset, orElse: () => null);
    final strBalance = balance == null ? '0' : balance.free.toString();
    return Text(strBalance + ' ' + asset, style: TextStyle(color: Colors.white60));
  }
}
