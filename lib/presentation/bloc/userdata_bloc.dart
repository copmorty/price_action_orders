import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/usecases/get_userdata.dart';

part 'userdata_event.dart';
part 'userdata_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final GetUserData getUserData;

  UserDataBloc({@required this.getUserData}) : super(UserdataInitial());

  @override
  Stream<UserDataState> mapEventToState(
    UserDataEvent event,
  ) async* {
    if (event is GetUserDataEvent) {
      final failureOrUserData = await getUserData(NoParams());
      yield failureOrUserData.fold(
        (failure) => ErrorUserData(message: 'sww w/ GetUserData'),
        (userData) => LoadedUserData(userData: userData),
      );
    }
  }
}
