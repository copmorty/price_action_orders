import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/presentation/logic/bookticker_state_notifier.dart';
import 'package:price_action_orders/presentation/widgets/bookticker_display.dart';
import 'package:price_action_orders/presentation/widgets/loading_widget.dart';
import 'package:price_action_orders/providers.dart';

class BookTickerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              height: double.infinity,
              width: double.infinity,
              child: Consumer(
                builder: (context, watch, child) {
                  final bookTickerState = watch(bookTickerNotifierProvider);
                  if (bookTickerState is BookTickerLoading) {
                    return LoadingWidget();
                  }
                  if (bookTickerState is BookTickerLoaded) {
                    return BookTickerDisplay(bookTicker: bookTickerState.bookTicker);
                  }
                  // bookTickerState is BookTickerInitial
                  return SizedBox();
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Pair')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Side')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Filled')),
                  DataColumn(label: Text('Total')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Now')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Now')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Now')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Now')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Now')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Now')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Now')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Now')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                    DataCell(Text('BTC/USD')),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
