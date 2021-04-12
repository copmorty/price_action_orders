part of 'userdata_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

class GetUserDataEvent extends UserDataEvent {}
