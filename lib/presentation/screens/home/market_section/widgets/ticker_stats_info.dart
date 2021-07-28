import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

class TickerStatsInfo extends StatelessWidget {
  final String label;
  final Decimal value;

  const TickerStatsInfo({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        Text(value.toString()),
      ],
    );
  }
}
