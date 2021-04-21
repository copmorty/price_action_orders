import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'home_bookticker_section.dart';
import 'home_controls_section.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WindowTitleBarBox(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: MoveWindow(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Price Action Orders'),
                      ),
                    ),
                  ),
                  WindowButtons(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Image.asset(
                  'assets/binance_logo_small.png',
                  width: 160,
                ),
                Expanded(child: SizedBox(width: 5)),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: appMode == AppMode.PRODUCTION ? Colors.yellow : Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    appMode.toShortString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: appMode == AppMode.PRODUCTION ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                BookTickerSection(),
                ControlsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(
          colors: closeButtonColors,
        ),
      ],
    );
  }
}

var buttonColors = WindowButtonColors(
  iconNormal: Colors.grey,
  iconMouseOver: Colors.grey,
  iconMouseDown: Colors.grey,
  mouseOver: Color(0x22FFFFFF),
  mouseDown: Color(0x22FFFFFF),
);
var closeButtonColors = WindowButtonColors(
  iconNormal: Colors.grey,
  mouseOver: Color(0xFFE53935),
  mouseDown: Color(0xFFE53935),
);
