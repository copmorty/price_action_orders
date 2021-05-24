import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/domain/entities/balance.dart';

class BalanceModel extends Balance {
  final String asset;
  final Decimal free;
  final Decimal locked;

  BalanceModel({
    @required this.asset,
    @required this.free,
    @required this.locked,
  });

  @override
  List<Object> get props => [asset, free, locked];

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
