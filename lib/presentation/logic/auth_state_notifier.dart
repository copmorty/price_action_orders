import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import 'package:price_action_orders/domain/usecases/user_check_account_status_uc.dart' as cas;
import 'package:price_action_orders/domain/usecases/user_clear_api_access_uc.dart' as caa;
import 'package:price_action_orders/domain/usecases/user_get_api_access_uc.dart' as gaa;
import 'package:price_action_orders/domain/usecases/user_store_api_access_uc.dart' as saa;

part 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final cas.CheckAccountStatus _checkAccountStatus;
  final gaa.GetApiAccess _getApiAccess;
  final saa.StoreApiAccess _storeApiAccess;
  final caa.ClearApiAccess _clearApiAccess;

  AuthNotifier({
    required cas.CheckAccountStatus checkAccountStatus,
    required gaa.GetApiAccess getApiAccess,
    required saa.StoreApiAccess storeApiAccess,
    required caa.ClearApiAccess clearApiAccess,
    bool init = true,
  })  : _checkAccountStatus = checkAccountStatus,
        _getApiAccess = getApiAccess,
        _storeApiAccess = storeApiAccess,
        _clearApiAccess = clearApiAccess,
        super(AuthInitial()) {
    if (init) this.initialization();
  }

  Future<void> initialization() async {
    state = AuthLoading();

    final failureOrSuccessTest = await _getApiAccess(gaa.Params(AppMode.TEST));
    final failureOrSuccessProd = await _getApiAccess(gaa.Params(AppMode.PRODUCTION));

    final ApiAccess? testApiAccess = failureOrSuccessTest.fold(
      (failure) => null,
      (apiAccess) => apiAccess,
    );
    final ApiAccess? prodApiAccess = failureOrSuccessProd.fold(
      (failure) => null,
      (apiAccess) => apiAccess,
    );

    state = AuthLoaded(testApiAccess: testApiAccess, prodApiAccess: prodApiAccess);
  }

  Future<bool> storeCredentials(AppMode mode, String key, String secret) async {
    final failureOrSuccess = await _storeApiAccess(saa.Params(mode, key, secret));

    return failureOrSuccess.fold(
      (failure) => false,
      (success) => true,
    );
  }

  Future<bool> clearCredentials(AppMode mode) async {
    final failureOrSuccess = await _clearApiAccess(caa.Params(mode));

    return failureOrSuccess.fold(
      (failure) => false,
      (success) => true,
    );
  }

  Future<bool> checkAuthCredentials(AppMode mode, String key, String secret) async {
    final failureOrSuccess = await _checkAccountStatus(cas.Params(mode, key, secret));

    return failureOrSuccess.fold(
      (failure) => false,
      (success) => true,
    );
  }
}
