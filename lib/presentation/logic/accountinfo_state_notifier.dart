import 'dart:async';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';
import 'package:price_action_orders/domain/usecases/get_user_accountinfo.dart';
import 'userdata_stream.dart';

part 'accountinfo_state.dart';

class AccountInfoNotifier extends StateNotifier<AccountInfoState> {
  final GetAccountInfo _getAccountInfo;
  final UserDataStream _userDataStream;
  StreamSubscription _subscription;

  AccountInfoNotifier({
    @required getAccountInfo,
    @required userDataStream,
    bool start = true,
  })  : _getAccountInfo = getAccountInfo,
        _userDataStream = userDataStream,
        super(AccountInfoInitial()) {
    if (start) this.getAccountInfo();
  }

  Future<void> getAccountInfo() async {
    state = AccountInfoLoading();

    await _subscription?.cancel();
    final failureOrUserData = await _getAccountInfo(NoParams());
    failureOrUserData.fold(
      (failure) => state = AccountInfoError(failure.message),
      (userData) {
        state = AccountInfoLoaded(userData);
        _subscription = _userDataStream.stream().listen(
              (data) => _checkForUpdate(data),
              onError: (error) => state = AccountInfoError('Account info not available right now.'),
              cancelOnError: true,
            );
      },
    );
  }

  void _checkForUpdate(dynamic data) {
    if (data is UserDataPayloadAccountUpdate) {
      _updateUserDataBalances(data.lastAccountUpdateTime, data.changedBalances);
    }
    // if (data is --balanceUpdate--) {
    // NEEDS LATER IMPLEMENTATION
    // }
  }

  void _updateUserDataBalances(int lastAccountUpdateTime, List<Balance> changedBalances) {
    if (!(state is AccountInfoLoaded)) return;

    final currentUserData = (state as AccountInfoLoaded).userData;
    final List<Balance> oldBalances = currentUserData.balances;
    final List<Balance> updatedBalances = [];

    oldBalances.retainWhere((oldElement) => changedBalances.firstWhere((element) => oldElement.asset == element.asset, orElse: () => null) == null);

    updatedBalances.addAll(oldBalances);
    updatedBalances.addAll(changedBalances);

    updatedBalances.sort((b1, b2) => b1.asset.compareTo(b2.asset));

    final updatedUserData = UserData(
      accountType: currentUserData.accountType,
      buyerCommission: currentUserData.buyerCommission,
      canDeposit: currentUserData.canDeposit,
      canTrade: currentUserData.canTrade,
      canWithdraw: currentUserData.canWithdraw,
      makerCommission: currentUserData.makerCommission,
      sellerCommission: currentUserData.sellerCommission,
      takerCommission: currentUserData.takerCommission,
      updateTime: lastAccountUpdateTime,
      permissions: currentUserData.permissions,
      balances: updatedBalances,
    );

    state = AccountInfoLoaded(updatedUserData);
  }
}
