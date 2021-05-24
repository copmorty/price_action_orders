import 'package:flutter/material.dart';

class ReloadWidget extends StatelessWidget {
  final Function callback;

  const ReloadWidget(this.callback, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(CircleBorder()),
        padding: MaterialStateProperty.all(EdgeInsets.all(30)),
        foregroundColor: MaterialStateProperty.all(Colors.indigo.shade300),
        overlayColor: MaterialStateProperty.all(Colors.indigo.shade400.withAlpha(20)),
      ),
      onPressed: callback,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.refresh),
          Text('Reload'),
        ],
      ),
    );
  }
}
