import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/presentation/logic/accountinfo_state_notifier.dart';
import 'package:price_action_orders/presentation/widgets/loading_widget.dart';
import 'package:price_action_orders/presentation/widgets/reload_widget.dart';

class SpotBalances extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Consumer(
        builder: (context, watch, child) {
          final accountInfoState = watch(accountInfoNotifierProvider);

          if (accountInfoState is AccountInfoLoading) {
            return LoadingWidget();
          }
          if (accountInfoState is AccountInfoError) {
            return ReloadWidget(() {
              context.read(userDataStream).initialization();
              context.read(accountInfoNotifierProvider.notifier).getAccountInfo();
            });
          }
          if (accountInfoState is AccountInfoLoaded) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: accountInfoState.userData.balances.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
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
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}
