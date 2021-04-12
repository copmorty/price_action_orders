import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/balance.dart';
import 'package:price_action_orders/domain/entities/rational.dart';

class BalanceModel extends Balance {
  final String asset;
  final Rational free;
  final Rational locked;

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
      free: Rational.parse(parsedJson['free']),
      locked: Rational.parse(parsedJson['locked']),
    );
  }
}
