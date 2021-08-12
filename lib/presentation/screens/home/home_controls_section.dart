import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/sizes.dart';
import 'controls_section/trade_panel.dart';
import 'controls_section/popup_manager.dart';
import 'controls_section/spot_balances.dart';

class ControlsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackColorOp12,
      padding: const EdgeInsets.all(SECTION_PADDING_ALL),
      child: Column(
        children: [
          // SizedBox(height: 10),
          SpotBalances(),
          // SizedBox(height: 10),
          TradePanel(),
          PopupManager(),
        ],
      ),
    );
  }
}
