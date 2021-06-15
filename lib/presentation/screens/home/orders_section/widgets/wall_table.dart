import 'package:flutter/material.dart';
import 'wall_table_cell.dart';

class WallTable extends StatelessWidget {
  final List<WallTableCell> headerCells;
  final Widget content;

  const WallTable({
    Key key,
    @required this.headerCells,
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [...headerCells],
        ),
        SizedBox(height: 5),
        Expanded(child: content),
      ],
    );
  }
}
