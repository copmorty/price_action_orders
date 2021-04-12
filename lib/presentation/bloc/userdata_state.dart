part of 'userdata_bloc.dart';

abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}

class UserdataInitial extends UserDataState {}

class EmptyUserData extends UserDataState {}

class LoadingUserData extends UserDataState {}

class LoadedUserData extends UserDataState {
  final UserData userData;

  LoadedUserData({@required this.userData});

  @override
  List<Object> get props => [userData];
}

class ErrorUserData extends UserDataState {
  final String message;

  ErrorUserData({@required this.message});

  @override
  List<Object> get props => [message];
}
