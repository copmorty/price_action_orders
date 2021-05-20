import 'package:decimal/decimal.dart';
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
            Text(
              bookTicker.ticker.baseAsset+'/'+bookTicker.ticker.quoteAsset,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            TableBookTicker(bookTicker: bookTicker),
          ],
        ),
      ],
    );
  }
}

class TableBookTicker extends StatelessWidget {
  final BookTicker bookTicker;

  const TableBookTicker({Key key, @required this.bookTicker}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            Text(
              'Price (${bookTicker.ticker.quoteAsset})',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Amount (${bookTicker.ticker.baseAsset})',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
        _buildBookRow(rowColor: Colors.red, price: bookTicker.askPrice, qty: bookTicker.askQty),
        _buildBookRow(rowColor: Colors.green, price: bookTicker.bidPrice, qty: bookTicker.bidQty),
      ],
    );
  }

  TableRow _buildBookRow({
    @required Color rowColor,
    @required Decimal price,
    @required Decimal qty,
  }) {
    return TableRow(
      children: [
        Container(
          child: Text(
            price.toStringAsFixed(8),
            style: TextStyle(
              color: rowColor,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: Text(
              qty.toStringAsFixed(8),
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 30,
                // fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
