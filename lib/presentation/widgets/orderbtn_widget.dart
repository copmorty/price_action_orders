import 'package:flutter/material.dart';

class OrderTypeBtn extends StatelessWidget {
  final int index;
  final bool selected;
  final Function onTapped;

  const OrderTypeBtn({Key key, @required this.index, @required this.selected, @required this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonLabel = index == 0
        ? 'Limit'
        : index == 1
            ? 'Market'
            : 'Stop-limit';

    return Container(
      decoration: selected ? BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.white))) : null,
      child: TextButton(
        onPressed: onTapped,
        style: TextButton.styleFrom(
          primary: selected ? Colors.white : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        ),
        child: Text(buttonLabel),
      ),
    );
  }
}
