// import 'dart:async';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:meta/meta.dart';
// import 'package:equatable/equatable.dart';
// import 'package:price_action_orders/core/usecases/usecase.dart';
// import 'package:price_action_orders/domain/entities/balance.dart';
// import 'package:price_action_orders/domain/entities/userdata.dart';
// import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';
// import 'package:price_action_orders/domain/usecases/get_userdata_accountinfo.dart';
// import 'package:price_action_orders/domain/usecases/get_userdata_stream.dart';
// import 'package:price_action_orders/presentation/logic/userdata_stream.dart';

// part 'userdata_state.dart';

// class UserDataNotifier extends StateNotifier<UserDataState> {
//   final GetAccountInfo _getUserData;
//   // final UserDataStream _userDataStream;
//   // final GetUserDataStream _streamUserData;
//   // StreamSubscription _subscription;

//   UserDataNotifier({
//     @required GetAccountInfo getUserData,
//     @required GetUserDataStream streamUserData,
//     // @required UserDataStream userDataStream,
//     bool start = true,
//   })  : _getUserData = getUserData,
//         // _streamUserData = streamUserData,
//         // _userDataStream = userDataStream,
//         super(UserDataInitial()) {
//     if (start) {
//       this.getUserData();
//       // this.streamUserData();
//       // _userDataStream.startup();
//     }
//   }

//   Future<void> getUserData() async {
//     print('RUN getUserData');
//     final failureOrUserData = await _getUserData(NoParams());
//     failureOrUserData.fold(
//       (failure) => state = UserDataError('sww w/ GetUserData'),
//       (userData) => state = UserDataLoaded(userData),
//     );
//   }

//   void updateBalances(UserDataPayloadAccountUpdate payload) {
//     print('IM updateBalances');
//     print(state);
//     if (state is UserDataLoaded) {
//       state = _updateUserDataBalances(payload.changedBalances);
//     }
//     print(state);
//   }

//   // Future<void> streamUserData() async {
//   //   await _subscription?.cancel();

//   //   final failureOrStream = await _streamUserData(NoParams());
//   //   failureOrStream.fold(
//   //     (failure) => state = UserDataError(failure.message),
//   //     (stream) {
//   //       _subscription = stream.listen((event) => state = _updateUserDataBalances(event.changedBalances));
//   //     },
//   //   );
//   // }

//   UserDataLoaded _updateUserDataBalances(List<Balance> changedBalances) {
//     if (!(state is UserDataLoaded)) throw UnimplementedError();

//     final currentUserData = (state as UserDataLoaded).userData;
//     final List<Balance> oldBalances = currentUserData.balances;
//     final List<Balance> updatedBalances = [];

//     oldBalances.retainWhere((oldElement) => changedBalances.firstWhere((element) => oldElement.asset == element.asset, orElse: () => null) == null);

//     updatedBalances.addAll(oldBalances);
//     updatedBalances.addAll(changedBalances);

//     updatedBalances.sort((b1, b2) => b1.asset.compareTo(b2.asset));

//     final updatedUserData = UserData(
//       accountType: currentUserData.accountType,
//       buyerCommission: currentUserData.buyerCommission,
//       canDeposit: currentUserData.canDeposit,
//       canTrade: currentUserData.canTrade,
//       canWithdraw: currentUserData.canWithdraw,
//       makerCommission: currentUserData.makerCommission,
//       sellerCommission: currentUserData.sellerCommission,
//       takerCommission: currentUserData.takerCommission,
//       updateTime: DateTime.now().millisecondsSinceEpoch,
//       permissions: currentUserData.permissions,
//       balances: updatedBalances,
//     );

//     return UserDataLoaded(updatedUserData);
//   }
// }
