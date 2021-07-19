import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';

const double CELL_FONT_SIZE = 13;
const FontWeight CELL_FONT_WEIGHT = FontWeight.w600;
const FontWeight CELL_FONT_WEIGHT_LIGHT =FontWeight.normal;

class WallTableCell extends StatelessWidget {
  final String? label;
  final Widget? child;
  final bool isHeader;
  final TextStyle? style;
  final TextStyle greyStyle = TextStyle(fontSize: CELL_FONT_SIZE, color: greyColor, fontWeight: CELL_FONT_WEIGHT_LIGHT);
  final TextStyle whiteStyle = TextStyle(fontSize: CELL_FONT_SIZE, color: whiteColorOp90, fontWeight: CELL_FONT_WEIGHT);

  WallTableCell({Key? key, this.label, this.child, this.isHeader = false, this.style})
      : assert((label != null || child != null) && !(label != null && child != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: child == null
          ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label!,
                style: isHeader ? greyStyle : style ?? whiteStyle,
              ),
            )
          : child,
    );
  }
}
