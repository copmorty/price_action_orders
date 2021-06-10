import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/presentation/logic/bookticker_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/sizes.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'market_section/bookticker_display.dart';

class MarketSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(SECTION_PADDING_ALL),
              height: double.infinity,
              width: double.infinity,
              child: Consumer(
                builder: (context, watch, child) {
                  final bookTickerState = watch(bookTickerNotifierProvider);
                  if (bookTickerState is BookTickerInitial) {
                    return Center(child: Text('Please enter Base & Quote assets'));
                  }
                  if (bookTickerState is BookTickerLoading) {
                    return LoadingWidget();
                  }
                  if (bookTickerState is BookTickerError) {
                    return _BookTickerErrorWidget();
                  }
                  if (bookTickerState is BookTickerLoaded) {
                    return BookTickerDisplay(bookTicker: bookTickerState.bookTicker);
                  }
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
