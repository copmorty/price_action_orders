import 'package:flutter/material.dart';

class RowDivision extends StatelessWidget {
  final String leftText;
  final String rightText;

  const RowDivision(this.leftText, this.rightText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(leftText, textAlign: TextAlign.right)),
        SizedBox(width: 5),
        Expanded(child: SelectableText(rightText, textAlign: TextAlign.left)),
      ],
    );
  }
}
