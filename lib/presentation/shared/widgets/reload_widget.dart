import 'package:flutter/material.dart';
import '../colors.dart';

class ReloadWidget extends StatelessWidget {
  final void Function() callback;

  const ReloadWidget(this.callback, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(CircleBorder()),
        padding: MaterialStateProperty.all(EdgeInsets.all(30)),
        foregroundColor: MaterialStateProperty.all(mainColor),
        overlayColor: MaterialStateProperty.all(mainColorDarkOp10),
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
