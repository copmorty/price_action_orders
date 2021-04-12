import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/bookticker_bloc.dart';
import 'package:price_action_orders/presentation/bloc/userdata_bloc.dart';
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
        // padding: EdgeInsets.all(5),
        child: bodyBuilder(context),
      ),
    );
  }

  MultiBlocProvider bodyBuilder(context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<BookTickerBloc>()),
        BlocProvider(create: (context) => sl<UserDataBloc>()..add(GetUserDataEvent())),
      ],
      child: Row(
        children: [
          Container(
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
          ),
          Container(
            color: Colors.black12,
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.all(10),
            child: BookTickerControls(),
          ),
        ],
      ),
    );
  }
}

class BookTickerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputSymbol(),
        SizedBox(height: 15),
        SpotBalances(),
      ],
    );
  }
}

class SpotBalances extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is LoadedUserData) {
          return Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.userData.balances.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.white),
                  //   borderRadius: BorderRadius.all(Radius.circular(5)),
                  // ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(state.userData.balances[index].asset),
                      Text(state.userData.balances[index].free.toShortString()),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}

class InputSymbol extends StatefulWidget {
  @override
  _InputSymbolState createState() => _InputSymbolState();
}

class _InputSymbolState extends State<InputSymbol> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      cursorColor: Colors.white,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        hintText: 'Put a symbol',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        suffixIcon: IconButton(
          color: Colors.white70,
          icon: Icon(Icons.send),
          onPressed: dispatchSymbol,
        ),
      ),
      onSubmitted: (_) => dispatchSymbol(),
      onChanged: (value) {
        _controller.text = value.toUpperCase();
        _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
      },
    );
  }

  void dispatchSymbol() {
    String symbol = _controller.text;
    if (symbol != '') {
      _controller.clear();
      FocusScope.of(context).unfocus();
      BlocProvider.of<BookTickerBloc>(context).add(GetBookTickerEvent(symbol));
      // BlocProvider.of<UserDataBloc>(context).add(GetUserDataEvent());
    }
  }
}
