import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/presentation/logic/accountinfo_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/presentation/shared/widgets/reload_widget.dart';

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
                      Text(
                        accountInfoState.userData.balances[index].asset,
                        style: TextStyle(color: whiteColorOp90, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        accountInfoState.userData.balances[index].free.toString(),
                        style: TextStyle(color: whiteColorOp90, fontWeight: FontWeight.normal),
                      ),
                      Row(
                        children: [
                          Icon(Icons.lock, color: whiteColorOp70, size: 12),
                          SizedBox(width: 2),
                          Text(
                            accountInfoState.userData.balances[index].locked.toString(),
                            style: TextStyle(color: whiteColorOp70, fontWeight: FontWeight.normal),
                          ),
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
