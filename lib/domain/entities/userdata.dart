import 'package:equatable/equatable.dart';
import 'balance.dart';

class UserData extends Equatable {
  final int/*!*/ updateTime;
  final int/*!*/ makerCommission;
  final int/*!*/ takerCommission;
  final int/*!*/ buyerCommission;
  final int/*!*/ sellerCommission;
  final bool/*!*/ canTrade;
  final bool/*!*/ canWithdraw;
  final bool/*!*/ canDeposit;
  final String/*!*/ accountType;
  final List<Balance>/*!*/ balances;
  final List<String>/*!*/ permissions;

  UserData({
    this.updateTime,
    this.makerCommission,
    this.takerCommission,
    this.buyerCommission,
    this.sellerCommission,
    this.canTrade,
    this.canWithdraw,
    this.canDeposit,
    this.accountType,
    this.balances,
    this.permissions,
  });

  @override
  List<Object> get props => [updateTime, accountType];
}
