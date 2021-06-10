import 'package:flutter/material.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'home_market_section.dart';
import 'home_controls_section.dart';
import 'home_orders_section.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Price Action Orders'),
            Expanded(child: SizedBox()),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: appMode == AppMode.PRODUCTION ? productionBackgroundColor : testBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                appMode.toShortString(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: appMode == AppMode.PRODUCTION ? productionTextColor : testTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 73,
              child: Row(
                children: [
                  Expanded(child: MarketSection()),
                  Expanded(child: ControlsSection()),
                ],
              ),
            ),
            Expanded(
              flex: 27,
              child: OrdersSection(),
            ),
          ],
        ),
      ),
    );
  }
}
