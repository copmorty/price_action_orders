import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/screens/home/controls_section/trade_panel.dart';
import 'package:price_action_orders/presentation/screens/home/controls_section/input_symbols.dart';
import 'package:price_action_orders/presentation/screens/home/controls_section/popup_manager.dart';
import 'package:price_action_orders/presentation/screens/home/controls_section/spot_balances.dart';

class ControlsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          InputSymbol(),
          SizedBox(height: 10),
          SpotBalances(),
          SizedBox(height: 10),
          TradePanel(),
          PopupManager(),
        ],
      ),
    );
  }
}
