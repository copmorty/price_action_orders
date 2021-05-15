part of 'accountinfo_state_notifier.dart';

abstract class AccountInfoState extends Equatable {
  const AccountInfoState();

  @override
  List<Object> get props => [];
}

class AccountInfoInitial extends AccountInfoState {}

class AccountInfoLoading extends AccountInfoState {}

class AccountInfoLoaded extends AccountInfoState {
  final UserData userData;

  AccountInfoLoaded(this.userData);

  @override
  List<Object> get props => [userData];
}

class AccountInfoError extends AccountInfoState {
  final String message;

  AccountInfoError(this.message);

  @override
  List<Object> get props => [message];
}
