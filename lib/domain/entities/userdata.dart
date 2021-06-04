import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'balance.dart';

class UserData extends Equatable {
  final int updateTime;
  final int makerCommission;
  final int takerCommission;
  final int buyerCommission;
  final int sellerCommission;
  final bool canTrade;
  final bool canWithdraw;
  final bool canDeposit;
  final String accountType;
  final List<Balance> balances;
  final List<String> permissions;

  UserData({
    @required this.updateTime,
    @required this.makerCommission,
    @required this.takerCommission,
    @required this.buyerCommission,
    @required this.sellerCommission,
    @required this.canTrade,
    @required this.canWithdraw,
    @required this.canDeposit,
    @required this.accountType,
    @required this.balances,
    @required this.permissions,
  });

  @override
  List<Object> get props => [updateTime, accountType];
}
