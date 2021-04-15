import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/screens/home_orders_section.dart';
import 'package:price_action_orders/presentation/widgets/inputsymbols_widget.dart';
import 'package:price_action_orders/presentation/widgets/popup_manager_widget.dart';
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
          PopupManager(),
        ],
      ),
    );
  }
}

// /// This is basically an empty UI widget that only
// /// manages the snackbar
// class SnackbarManager extends StatelessWidget {
//   Timer _timer;

//   @override
//   Widget build(BuildContext buildContext) {
//     return BlocListener<OrderBloc, OrderState>(
//       listener: (context, state) {
//         if (state is LoadedMarketOrder) {
//           final bool orderCompleted = state.orderResponse.status == BinanceOrderStatus.FILLED;
//           showDialog(
//             barrierDismissible: orderCompleted ? false : true,
//             context: context,
//             builder: (context) {
//               if (orderCompleted) {
//                 _timer = Timer(Duration(seconds: 5), () {
//                   Navigator.of(context).pop();
//                 });
//                 // Future.delayed(Duration(seconds: 10), () {
//                 //   Navigator.of(buildContext).pop(true);
//                 // });
//               }
//               return AlertDialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//                 contentPadding: const EdgeInsets.all(0),
//                 content: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     border: Border.all(
//                       width: 2,
//                       color: orderCompleted
//                           ? state.orderResponse.side == BinanceOrderSide.BUY
//                               ? Colors.green
//                               : Colors.red
//                           : Colors.transparent,
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(state.orderResponse.symbol, textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
//                       SizedBox(height: 20),
//                       RichText(
//                         text: TextSpan(
//                           style: TextStyle(fontSize: 25),
//                           children: [
//                             TextSpan(text: state.orderResponse.type.toShortString()),
//                             TextSpan(text: ' '),
//                             TextSpan(
//                               text: state.orderResponse.side.toShortString(),
//                               style: TextStyle(color: state.orderResponse.side == BinanceOrderSide.BUY ? Colors.green : Colors.red),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Text('price: ' + state.orderResponse.price),
//                       Text('status: ' + state.orderResponse.status.toShortString()),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ).then(
//             (_) {
//               if (_timer.isActive) {
//                 _timer.cancel();
//               }
//             },
//           );
//         }
//       },
//       child: SizedBox(),
//     );
//   }
// }