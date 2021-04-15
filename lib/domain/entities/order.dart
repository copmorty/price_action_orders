import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:meta/meta.dart';

class Order extends Equatable {
  final String symbol;
  final BinanceOrderSide side;
  final BinanceOrderType type;
  final int timestamp;

  Order({
    @required this.symbol,
    @required this.side,
    @required this.type,
    @required this.timestamp,
  });

  @override
  List<Object> get props => [symbol, side, type, timestamp];
}
