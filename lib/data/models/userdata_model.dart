import 'dart:convert';
import 'package:price_action_orders/data/models/balance_model.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:meta/meta.dart';

class UserDataModel extends UserData {
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

  UserDataModel({
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
  List<Object> get props => [updateTime];

  factory UserDataModel.fromStringifiedMap(String strMap) {
    final Map data = jsonDecode(strMap);

    var bList = data['balances'] as List;
    List<Balance> balancesList = bList.map((item) => BalanceModel.fromJson(item)).toList();
    List<String> permissionsList = List<String>.from(data['permissions']);

    return UserDataModel(
      updateTime: data['updateTime'],
      makerCommission: data['makerCommission'],
      takerCommission: data['takerCommission'],
      buyerCommission: data['buyerCommission'],
      sellerCommission: data['sellerCommission'],
      canTrade: data['canTrade'],
      canWithdraw: data['canWithdraw'],
      canDeposit: data['canDeposit'],
      accountType: data['accountType'],
      permissions: permissionsList,
      balances: balancesList,
    );
  }
}
