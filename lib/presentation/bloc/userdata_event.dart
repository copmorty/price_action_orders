part of 'userdata_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

class GetUserDataEvent extends UserDataEvent {}

class StreamUserDataEvent extends UserDataEvent {}

class _ChangedBalancesUserDataEvent extends UserDataEvent {
  final List<Balance> changedBalances;

  _ChangedBalancesUserDataEvent(this.changedBalances);

  @override
  List<Object> get props => [changedBalances];
}
