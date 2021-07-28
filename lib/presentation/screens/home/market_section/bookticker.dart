import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/presentation/logic/bookticker_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/providers.dart';

class BookTickerBoard extends ConsumerWidget {
  const BookTickerBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final bookTickerState = watch(bookTickerNotifierProvider);

    if (bookTickerState is BookTickerInitial) return Center(child: Text('Please enter Base & Quote assets'));
    if (bookTickerState is BookTickerLoading) return LoadingWidget();
    if (bookTickerState is BookTickerError) return _BookTickerErrorWidget();
    if (bookTickerState is BookTickerLoaded) return _BookTickerDisplay(bookTicker: bookTickerState.bookTicker);

    return SizedBox();
  }
}

class _BookTickerDisplay extends StatelessWidget {
  final BookTicker bookTicker;

  const _BookTickerDisplay({
    Key? key,
    required this.bookTicker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      // fit: StackFit.expand,
      children: [
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   child: Text(
        //     bookTicker.updatedId.toString(),
        //     style: TextStyle(color: whiteColor, fontSize: 10),
        //   ),
        // ),
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
  final BookTicker bookTicker;

  const _TableBookTicker({
    Key? key,
    required this.bookTicker,
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
    required Color rowColor,
    required Decimal price,
    required Decimal qty,
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

class _BookTickerErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_sharp, size: 60),
        SizedBox(height: 10),
        Text('Error', style: TextStyle(fontSize: 20)),
        SizedBox(height: 5),
        Text('Something went wrong. Please re-enter Base and Quote assets'),
      ],
    );
  }
}
