import 'package:flutter/material.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';

class BookTickerDisplay extends StatelessWidget {
  final BookTicker bookTicker;

  const BookTickerDisplay({
    Key key,
    @required this.bookTicker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      // fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Text(
            bookTicker.updatedId.toString(),
            style: TextStyle(fontSize: 10),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(bookTicker.symbol),
            SizedBox(
              height: 10,
            ),
            Container(
              // color: Colors.red,
              padding: EdgeInsets.all(10),
              child: Text(
                bookTicker.askPrice.toString(),
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              // width: double.infinity,
              // color: Colors.green,
              padding: EdgeInsets.all(10),
              child: Text(
                bookTicker.bidPrice.toString(),
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
