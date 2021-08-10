import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:price_action_orders/core/extensions/decimal_extension.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';

class TickerStatsInfo extends StatelessWidget {
  final String label;
  final Decimal value;
  final int? decimalDigits;

  const TickerStatsInfo({
    Key? key,
    required this.label,
    required this.value,
    this.decimalDigits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: whiteColorOp70)),
        SizedBox(height: 5),
        Text(value.toCrypto(decimalDigits: decimalDigits), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
