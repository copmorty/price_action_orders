import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/presentation/logic/accountinfo_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';

class TradeFormHeader extends StatelessWidget {
  final String baseAsset;
  final String quoteAsset;
  final BinanceOrderSide side;

  const TradeFormHeader({
    Key key,
    @required this.baseAsset,
    @required this.quoteAsset,
    @required this.side,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            (side == BinanceOrderSide.BUY ? 'Buy ' : 'Sell ') + baseAsset,
            style: TextStyle(color: whiteColorOp90, fontSize: 18),
          ),
        ),
        Icon(Icons.account_balance_wallet_outlined, color: whiteColorOp60),
        SizedBox(width: 5),
        Consumer(
          builder: (context, watch, child) {
            final accountInfoState = watch(accountInfoNotifierProvider);

            if (accountInfoState is AccountInfoLoaded) {
              return _BalanceForOrder(
                asset: side == BinanceOrderSide.BUY ? quoteAsset : baseAsset,
                balances: accountInfoState.userData.balances,
              );
            }

            return SizedBox();
          },
        ),
      ],
    );
  }
}

class _BalanceForOrder extends StatelessWidget {
  final List<Balance> balances;
  final String asset;

  const _BalanceForOrder({Key key, @required this.balances, @required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balance = balances.firstWhere((element) => element.asset == asset, orElse: () => null);
    final strBalance = balance == null ? '0' : balance.free.toString();

    return Text(strBalance + ' ' + asset, style: TextStyle(color: whiteColorOp60));
  }
}
