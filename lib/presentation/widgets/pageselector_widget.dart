import 'package:flutter/material.dart';

class PageSelector extends StatelessWidget {
  final String label;
  final bool selected;
  final Function onTapped;

  const PageSelector({Key key, @required this.label, @required this.selected, @required this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: selected ? BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.white))) : null,
      child: TextButton(
        onPressed: onTapped,
        style: TextButton.styleFrom(
          primary: selected ? Colors.white : Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        ),
        child: Text(label),
      ),
    );
  }
}
