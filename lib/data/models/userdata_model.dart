import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/data/models/balance_model.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/entities/balance.dart';

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

  factory UserDataModel.fromJson(Map<String, dynamic> parsedJson) {
    var bList = parsedJson['balances'] as List;
    List<Balance> balancesList =
        bList.map((item) => BalanceModel.fromJson(item)).where((balance) => balance.free != Decimal.zero || balance.locked != Decimal.zero).toList();
    List<String> permissionsList = List<String>.from(parsedJson['permissions']);

    return UserDataModel(
      updateTime: parsedJson['updateTime'],
      makerCommission: parsedJson['makerCommission'],
      takerCommission: parsedJson['takerCommission'],
      buyerCommission: parsedJson['buyerCommission'],
      sellerCommission: parsedJson['sellerCommission'],
      canTrade: parsedJson['canTrade'],
      canWithdraw: parsedJson['canWithdraw'],
      canDeposit: parsedJson['canDeposit'],
      accountType: parsedJson['accountType'],
      permissions: permissionsList,
      balances: balancesList,
    );
  }
}
