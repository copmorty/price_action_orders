import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/usecases/get_user_account_status.dart';

class AuthHandler {
  final CheckAccountStatus _checkAccountStatus;

  AuthHandler({
    required CheckAccountStatus checkAccountStatus,
  }) : _checkAccountStatus = checkAccountStatus;

  Future<bool> checkAuthCredentials(AppMode mode, String key, String secret) async {
    final failureOrSuccess = await _checkAccountStatus(Params(mode, key, secret));
    return failureOrSuccess.fold(
      (failure) => false,
      (success) => true,
    );
  }
}
