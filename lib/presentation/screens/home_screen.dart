import 'package:flutter/material.dart';
import 'home_bookticker_section.dart';
import 'home_controls_section.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Action Orders'),
      ),
      body: Container(
        child: bodyBuilder(context),
      ),
    );
  }

  Widget bodyBuilder(context) {
    return Row(
      children: [
        BookTickerSection(),
        ControlsSection(),
      ],
    );
  }
}
