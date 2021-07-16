import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';

class BookTickerDisplay extends StatelessWidget {
  final BookTicker /*!*/ bookTicker;

  const BookTickerDisplay({
    Key key,
    this.bookTicker,
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
            style: TextStyle(color: whiteColor, fontSize: 10),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              bookTicker.ticker.baseAsset + '/' + bookTicker.ticker.quoteAsset,
              style: TextStyle(color: whiteColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            _TableBookTicker(bookTicker: bookTicker),
          ],
        ),
      ],
    );
  }
}

class _TableBookTicker extends StatelessWidget {
  final BookTicker /*!*/ bookTicker;

  const _TableBookTicker({
    Key key,
    this.bookTicker,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            Text(
              'Price (${bookTicker.ticker.quoteAsset})',
              style: TextStyle(
                color: whiteColorOp30,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Amount (${bookTicker.ticker.baseAsset})',
                style: TextStyle(
                  color: whiteColorOp30,
                ),
              ),
            ),
          ],
        ),
        _buildBookRow(rowColor: sellColor, price: bookTicker.askPrice, qty: bookTicker.askQty),
        _buildBookRow(rowColor: buyColor, price: bookTicker.bidPrice, qty: bookTicker.bidQty),
      ],
    );
  }

  TableRow _buildBookRow({
    Color/*!*/ rowColor,
    Decimal/*!*/ price,
    Decimal/*!*/ qty,
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
                color: whiteColorOp50,
                fontSize: 30,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
