import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/bloc/bookticker_bloc.dart';
import 'package:price_action_orders/presentation/widgets/bookticker_display.dart';
import 'package:price_action_orders/presentation/widgets/loading_widget.dart';

import '../../injection_container.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Action Orders'),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: bodyBuilder(context),
      ),
    );
  }

  BlocProvider<BookTickerBloc> bodyBuilder(context) {
    return BlocProvider(
      create: (_) => sl<BookTickerBloc>(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    height: double.infinity,
                    width: double.infinity,
                    child: BlocBuilder<BookTickerBloc, BookTickerState>(
                      builder: (context, state) {
                        if (state is Empty) {
                          return Text('Empty');
                        } else if (state is Loading) {
                          return LoadingWidget();
                        } else if (state is Loaded) {
                          return BookTickerDisplay(
                              bookTicker: state.bookTicker);
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
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              child: BookTickerControls(),
            ),
          ),
        ],
      ),
    );
  }
}

class BookTickerControls extends StatefulWidget {
  const BookTickerControls({
    Key key,
  }) : super(key: key);

  @override
  _BookTIckerControlsState createState() => _BookTIckerControlsState();
}

class _BookTIckerControlsState extends State<BookTickerControls> {
  void dispatchWS() {
    BlocProvider.of<BookTickerBloc>(context).add(GetBookTickerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () => dispatchWS(),
        child: Text('Start'),
      ),
    );
  }
}
