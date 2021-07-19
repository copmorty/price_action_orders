import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/globals/enums.dart';

class UserDataPayload extends Equatable {
  final BinanceUserDataPayloadEventType eventType;
  final int eventTime;

  UserDataPayload({
    required this.eventType,
    required this.eventTime,
  });

  @override
  List<Object> get props => [eventType, eventTime];
}
