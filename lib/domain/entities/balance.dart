import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Balance extends Equatable {
  final String asset;
  final Decimal free;
  final Decimal locked;

  Balance({
    @required this.asset,
    @required this.free,
    @required this.locked,
  });

  @override
  List<Object> get props => [asset, free, locked];
}