import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class UserDataPayload extends Equatable {
  final String eventType;
  final int eventTime;

  UserDataPayload({
    @required this.eventType,
    @required this.eventTime,
  });

  @override
  List<Object> get props => [eventType, eventTime];
}
