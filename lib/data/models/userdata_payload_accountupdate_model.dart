import 'package:meta/meta.dart';
import 'package:price_action_orders/data/models/balance_model.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';

class UserDataPayloadAccountUpdateModel extends UserDataPayloadAccountUpdate {
  UserDataPayloadAccountUpdateModel({
    @required eventType,
    @required eventTime,
    @required lastAccountUpdateTime,
    @required changedBalances,
  }) : super(
          eventType: eventType,
          eventTime: eventTime,
          lastAccountUpdateTime: lastAccountUpdateTime,
          changedBalances: changedBalances,
        );

  @override
  List<Object> get props => [lastAccountUpdateTime];

  factory UserDataPayloadAccountUpdateModel.fromJson(Map jsonData) {
    var bList = jsonData['B'] as List;
    List<Balance> balancesList = bList.map((item) => BalanceModel.fromJsonStream(item)).toList();

    return UserDataPayloadAccountUpdateModel(
      eventType: jsonData['e'],
      eventTime: jsonData['E'],
      lastAccountUpdateTime: jsonData['u'],
      changedBalances: balancesList,
    );
  }
}
