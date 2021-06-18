import 'package:meta/meta.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/balance_model.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';

class UserDataPayloadAccountUpdateModel extends UserDataPayloadAccountUpdate {
  UserDataPayloadAccountUpdateModel({
    @required BinanceUserDataPayloadEventType eventType,
    @required int eventTime,
    @required int lastAccountUpdateTime,
    @required List<Balance> changedBalances,
  }) : super(
          eventType: eventType,
          eventTime: eventTime,
          lastAccountUpdateTime: lastAccountUpdateTime,
          changedBalances: changedBalances,
        );

  factory UserDataPayloadAccountUpdateModel.fromJson(Map<String, dynamic> parsedJson) {
    var bList = parsedJson['B'] as List;
    List<Balance> balancesList = bList.map((item) => BalanceModel.fromJsonStream(item)).toList();

    return UserDataPayloadAccountUpdateModel(
      eventType: BinanceUserDataPayloadEventType.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['e'], orElse: () => null),
      eventTime: parsedJson['E'],
      lastAccountUpdateTime: parsedJson['u'],
      changedBalances: balancesList,
    );
  }
}
