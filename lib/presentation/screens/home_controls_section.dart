import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/screens/home_orders_section.dart';
import 'package:price_action_orders/presentation/widgets/inputsymbols_widget.dart';
import 'package:price_action_orders/presentation/widgets/spotbalances_widget.dart';

class ControlsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      width: MediaQuery.of(context).size.width / 2,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          InputSymbol(),
          SizedBox(height: 15),
          SpotBalances(),
          SizedBox(height: 15),
          OrdersSection(),
        ],
      ),
    );
  }
}
