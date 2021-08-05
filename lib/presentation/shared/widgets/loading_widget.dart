import 'package:flutter/material.dart';
import '../colors.dart';

class LoadingWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const LoadingWidget({Key? key, this.height, this.width, this.color, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: padding,
        height: height,
        width: width,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(color ?? mainColor),
        ),
      ),
    );
  }
}
