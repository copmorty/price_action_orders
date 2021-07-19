import 'package:decimal/decimal.dart';
import 'package:price_action_orders/data/models/balance_model.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/entities/balance.dart';

class UserDataModel extends UserData {
  UserDataModel({
    required int updateTime,
    required int makerCommission,
    required int takerCommission,
    required int buyerCommission,
    required int sellerCommission,
    required bool canTrade,
    required bool canWithdraw,
    required bool canDeposit,
    required String accountType,
    required List<Balance> balances,
    required List<String> permissions,
  }) : super(
          updateTime: updateTime,
          makerCommission: makerCommission,
          takerCommission: takerCommission,
          buyerCommission: buyerCommission,
          sellerCommission: sellerCommission,
          canTrade: canTrade,
          canWithdraw: canWithdraw,
          canDeposit: canDeposit,
          accountType: accountType,
          balances: balances,
          permissions: permissions,
        );

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
