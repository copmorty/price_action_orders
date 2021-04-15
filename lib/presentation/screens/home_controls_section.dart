import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/order_bloc.dart';
import 'package:price_action_orders/presentation/screens/home_orders_section.dart';
import 'package:price_action_orders/presentation/widgets/inputsymbols_widget.dart';
import 'package:price_action_orders/presentation/widgets/spotbalances_widget.dart';

class ControlsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      width: MediaQuery.of(context).size.width / 2,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          InputSymbol(),
          SizedBox(height: 15),
          SpotBalances(),
          SizedBox(height: 15),
          OrdersSection(),
          SnackbarManager(),
        ],
      ),
    );
  }
}

/// This is basically an empty UI widget that only
/// manages the snackbar
class SnackbarManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is LoadedMarketOrder) {
          showDialog(
              barrierDismissible: false, //Mandatory for automatically closing the dialog
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(context).pop(true);
                });
                return AlertDialog(
                  title: Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 50,
                  ),
                  content: Text(
                    'Market Order completed',
                    textAlign: TextAlign.center,
                  ),
                );
              });
        }
      },
      child: SizedBox(),
    );
  }
}
