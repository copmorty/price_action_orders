import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/presentation/logic/accountinfo_state_notifier.dart';

class SpotBalances extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final accountInfoState = watch(accountInfoNotifierProvider);
    if (accountInfoState is AccountInfoLoaded) {
    // final userDataState = watch(userDataNotifierProvider);
    // if (userDataState is UserDataLoaded) {
      return Container(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: accountInfoState.userData.balances.length,
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
                  Text(accountInfoState.userData.balances[index].asset),
                  Text(accountInfoState.userData.balances[index].free.toString()),
                  Row(
                    children: [
                      Icon(Icons.lock, size: 12),
                      SizedBox(width: 2),
                      Text(accountInfoState.userData.balances[index].locked.toString()),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
    return SizedBox();
  }
}
