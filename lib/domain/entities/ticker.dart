import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class Ticker extends Equatable {
  final String baseAsset;
  final String quoteAsset;

  Ticker({
    @required this.baseAsset,
    @required this.quoteAsset,
  });

  @override
  List<Object> get props => [baseAsset, quoteAsset];
}
