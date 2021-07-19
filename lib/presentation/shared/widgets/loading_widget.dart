import 'package:flutter/material.dart';
import '../colors.dart';

class LoadingWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const LoadingWidget({Key? key, this.height, this.width, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(color ?? mainColor),
        ),
      ),
    );
  }
}
