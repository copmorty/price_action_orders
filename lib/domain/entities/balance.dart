import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'rational.dart';

class Balance extends Equatable {
  final String asset;
  final Rational free;
  final Rational locked;

  Balance({
    @required this.asset,
    @required this.free,
    @required this.locked,
  });

  @override
  List<Object> get props => [asset, free, locked];
}