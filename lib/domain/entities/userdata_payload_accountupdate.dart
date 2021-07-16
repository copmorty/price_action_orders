import 'package:price_action_orders/core/globals/enums.dart';
import 'balance.dart';
import 'userdata_payload.dart';

class UserDataPayloadAccountUpdate extends UserDataPayload {
  final int/*!*/ lastAccountUpdateTime;
  final List<Balance>/*!*/ changedBalances;

  UserDataPayloadAccountUpdate({
    BinanceUserDataPayloadEventType/*!*/ eventType,
    int/*!*/ eventTime,
    this.lastAccountUpdateTime,
    this.changedBalances,
  }) : super(eventType: eventType, eventTime: eventTime);

  @override
  List<Object> get props => super.props..addAll([lastAccountUpdateTime]);
}
