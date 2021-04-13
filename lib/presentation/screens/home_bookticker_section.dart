import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/bookticker_bloc.dart';
import 'package:price_action_orders/presentation/widgets/bookticker_display.dart';
import 'package:price_action_orders/presentation/widgets/loading_widget.dart';

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
              child: BlocBuilder<BookTickerBloc, BookTickerState>(
                builder: (context, state) {
                  if (state is EmptyBookTicker) {
                    return Text('Empty');
                  } else if (state is LoadingBookTicker) {
                    return LoadingWidget();
                  } else if (state is LoadedBookTicker) {
                    return BookTickerDisplay(bookTicker: state.bookTicker);
                  }
                  return Container();
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
