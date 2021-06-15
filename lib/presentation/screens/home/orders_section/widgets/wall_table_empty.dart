import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';

class WallTableEmpty extends StatelessWidget {
  final String message;

  const WallTableEmpty(this.message, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: TextStyle(color: greyColor)),
    );
  }
}
