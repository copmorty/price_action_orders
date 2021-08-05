import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';

class TickerStatsChangeInfo extends StatelessWidget {
  final Decimal priceChange;
  final Decimal priceChangePercent;

  const TickerStatsChangeInfo({
    Key? key,
    required this.priceChange,
    required this.priceChangePercent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Color priceColor;
    final String p = priceChange.toString();
    String pp = '';

    if (priceChangePercent.isNegative)
      priceColor = sellColor;
    else {
      priceColor = buyColor;
      pp = '+';
    }

    pp = pp + priceChangePercent.toStringAsFixed(2) + '%';

    return Column(
      children: [
        Text('24h Change', style: TextStyle(fontSize: 10, color: whiteColorOp70)),
        SizedBox(height: 5),
        Text(
          '$p $pp',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: priceColor),
        ),
      ],
    );
  }
}
