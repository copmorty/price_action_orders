import 'package:equatable/equatable.dart';
import 'package:decimal/decimal.dart';

class Balance extends Equatable {
  final String /*!*/ asset;
  final Decimal/*!*/ free;
  final Decimal/*!*/ locked;

  Balance({
    this.asset,
    this.free,
    this.locked,
  });

  @override
  List<Object> get props => [asset, free, locked];
}
