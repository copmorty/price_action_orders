import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/userdata_bloc.dart';
import 'package:price_action_orders/presentation/logic/userdata_state_notifier.dart';
import 'package:price_action_orders/providers.dart';
import 'balancefororder_widget.dart';

class BuyHeader extends StatelessWidget {
  final String baseAsset;
  final String quoteAsset;

  const BuyHeader({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Buy ' + baseAsset,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Icon(Icons.account_balance_wallet_outlined, color: Colors.white60),
        SizedBox(width: 5),
        Consumer(builder: (context, watch, child) {
          final userDataState = watch(userDataNotifierProvider);
          if (userDataState is UserDataLoaded) {
            return BalanceForOrder(asset: quoteAsset, balances: userDataState.userData.balances);
          }
          return SizedBox();
        }),
        // BlocBuilder<UserDataBloc, UserDataState>(builder: (context, state) {
        //   if (state is LoadedUserData) {
        //     return BalanceForOrder(asset: quoteAsset, balances: state.userData.balances);
        //   }
        //   return SizedBox();
        // }),
        // Text('222.11', style: TextStyle(color: Colors.white60)),
      ],
    );
  }
}
