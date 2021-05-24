import 'package:meta/meta.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'balance.dart';
import 'userdata_payload.dart';

class UserDataPayloadAccountUpdate extends UserDataPayload {
  final int lastAccountUpdateTime;
  final List<Balance> changedBalances;

  UserDataPayloadAccountUpdate({
    @required BinanceUserDataPayloadEventType eventType,
    @required int eventTime,
    @required this.lastAccountUpdateTime,
    @required this.changedBalances,
  }) : super(eventType: eventType, eventTime: eventTime);

  @override
  List<Object> get props => [lastAccountUpdateTime];
}
