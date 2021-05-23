import 'package:flutter/material.dart';

class WallTableCell extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isHeader;
  final TextStyle style;
  final TextStyle greyStyle = TextStyle(color: Colors.white54, fontWeight: FontWeight.normal);
  final TextStyle whiteStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500);

  WallTableCell({Key key, this.label, this.child, this.isHeader = false, this.style})
      : assert((label != null || child != null) && !(label != null && child != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.pink,
      width: 100,
      child: child == null
          ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: isHeader ? greyStyle : style ?? whiteStyle,
              ),
            )
          : child,
    );
  }
}
