import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/userdata_bloc.dart';
import 'balancefororder_widget.dart';

class SellHeader extends StatelessWidget {
  final String baseAsset;
  final String quoteAsset;

  const SellHeader({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Sell ' + baseAsset,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Icon(Icons.account_balance_wallet_outlined, color: Colors.white60),
        SizedBox(width: 5),
        BlocBuilder<UserDataBloc, UserDataState>(builder: (context, state) {
          if (state is LoadedUserData) {
            return BalanceForOrder(asset: baseAsset, balances: state.userData.balances);
          }
          return SizedBox();
        }),
        // Text('0.11', style: TextStyle(color: Colors.white60)),
      ],
    );
  }
}
