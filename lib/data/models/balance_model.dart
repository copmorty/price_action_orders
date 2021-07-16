import 'package:decimal/decimal.dart';
import 'package:price_action_orders/domain/entities/balance.dart';

class BalanceModel extends Balance {
  BalanceModel({
    String/*!*/ asset,
    Decimal/*!*/ free,
    Decimal/*!*/ locked,
  }) : super(
          asset: asset,
          free: free,
          locked: locked,
        );

  factory BalanceModel.fromJson(Map<String, dynamic> parsedJson) {
    return BalanceModel(
      asset: parsedJson['asset'],
      free: Decimal.parse(parsedJson['free']),
      locked: Decimal.parse(parsedJson['locked']),
    );
  }

  factory BalanceModel.fromJsonStream(Map<String, dynamic> parsedJson) {
    return BalanceModel(
      asset: parsedJson['a'],
      free: Decimal.parse(parsedJson['f']),
      locked: Decimal.parse(parsedJson['l']),
    );
  }
}
