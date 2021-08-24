import 'package:price_action_orders/domain/entities/api_access.dart';

class ApiAccessModel extends ApiAccess {
  ApiAccessModel({
    required String key,
    required String secret,
  }) : super(
          key: key,
          secret: secret,
        );

  factory ApiAccessModel.fromApiAccess(ApiAccess apiAccess) {
    return ApiAccessModel(
      key: apiAccess.key,
      secret: apiAccess.secret,
    );
  }

  factory ApiAccessModel.fromJson(Map<String, dynamic> json) {
    return ApiAccessModel(
      key: json['key'],
      secret: json['secret'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'secret': secret,
    };
  }
}
