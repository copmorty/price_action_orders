import 'package:equatable/equatable.dart';

class Ticker extends Equatable {
  final String/*!*/ baseAsset;
  final String/*!*/ quoteAsset;

  Ticker({
    this.baseAsset,
    this.quoteAsset,
  });

  @override
  List<Object> get props => [baseAsset, quoteAsset];
}
