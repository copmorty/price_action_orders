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
        ],
      ),
    );
  }
}
