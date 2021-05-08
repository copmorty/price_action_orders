// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:equatable/equatable.dart';
// import 'package:price_action_orders/core/usecases/usecase.dart';
// import 'package:price_action_orders/domain/entities/balance.dart';
// import 'package:price_action_orders/domain/entities/userdata.dart';
// import 'package:price_action_orders/domain/usecases/get_userdata.dart';
// import 'package:price_action_orders/domain/usecases/stream_userdata.dart';

// part 'userdata_event.dart';
// part 'userdata_state.dart';

// class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
//   final GetUserData getUserData;
//   final StreamUserData streamUserData;
//   StreamSubscription _subscription;
//   UserData currentUserData;

//   UserDataBloc({@required this.streamUserData, @required this.getUserData}) : super(UserdataInitial()) {
//     add(GetUserDataEvent());
//     add(StreamUserDataEvent());
//   }

//   @override
//   Stream<UserDataState> mapEventToState(
//     UserDataEvent event,
//   ) async* {
//     if (event is GetUserDataEvent) {
//       final failureOrUserData = await getUserData(NoParams());
//       yield failureOrUserData.fold(
//         (failure) => ErrorUserData(message: 'sww w/ GetUserData'),
//         (userData) {
//           currentUserData = userData;
//           return LoadedUserData(userData: userData);
//         },
//       );
//     }

//     if (event is StreamUserDataEvent) {
//       await _subscription?.cancel();
//       final failureOrStream = await streamUserData(NoParams());
//       failureOrStream.fold(
//         (failure) => ErrorUserData(message: failure.message),
//         (stream) {
//           _subscription = stream.listen((event) => add(_ChangedBalancesUserDataEvent(event.changedBalances)));
//         },
//       );
//     }

//     if (event is _ChangedBalancesUserDataEvent) {
//       final List<Balance> oldBalances = currentUserData.balances;
//       final List<Balance> updatedBalances = [];

//       oldBalances
//           .retainWhere((oldElement) => event.changedBalances.firstWhere((element) => oldElement.asset == element.asset, orElse: () => null) == null);

//       updatedBalances.addAll(oldBalances);
//       updatedBalances.addAll(event.changedBalances);

//       updatedBalances.sort((b1, b2) => b1.asset.compareTo(b2.asset));

//       currentUserData = UserData(
//         accountType: currentUserData.accountType,
//         buyerCommission: currentUserData.buyerCommission,
//         canDeposit: currentUserData.canDeposit,
//         canTrade: currentUserData.canTrade,
//         canWithdraw: currentUserData.canWithdraw,
//         makerCommission: currentUserData.makerCommission,
//         sellerCommission: currentUserData.sellerCommission,
//         takerCommission: currentUserData.takerCommission,
//         updateTime: DateTime.now().millisecondsSinceEpoch,
//         permissions: currentUserData.permissions,
//         balances: updatedBalances,
//       );

//       yield LoadedUserData(userData: currentUserData);
//     }
//   }
// }
