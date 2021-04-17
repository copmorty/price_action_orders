import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/userdata_payload.dart';

class UserDataPayloadAccountUpdate extends UserDataPayload {
  final int lastAccountUpdateTime;
  final List<Balance> changedBalances;

  UserDataPayloadAccountUpdate({
    @required eventType,
    @required eventTime,
    @required this.lastAccountUpdateTime,
    @required this.changedBalances,
  }) : super(eventType: eventType, eventTime: eventTime);

  @override
  List<Object> get props => [lastAccountUpdateTime];
}
