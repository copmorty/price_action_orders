import 'package:flutter/material.dart';
import 'wall_table_cell.dart';

class WallTableRow extends StatelessWidget {
  final List<WallTableCell> cells;
  final double opacity;

  const WallTableRow({
    Key key,
    @required this.cells,
    this.opacity = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Opacity(
        opacity: opacity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [...cells],
        ),
      ),
    );
  }
}
