import 'package:equatable/equatable.dart';
import 'ticker.dart';

class OrderResponse extends Equatable {
  final Ticker/*!*/ ticker;
  final String/*!*/ symbol;
  final int/*!*/ orderId;
  final int/*!*/ orderListId;
  final String/*!*/ clientOrderId;
  final int/*!*/ transactTime;

  OrderResponse({
    this.ticker,
    this.symbol,
    this.orderId,
    this.orderListId,
    this.clientOrderId,
    this.transactTime,
  });

  @override
  List<Object> get props => [symbol, orderId];
}
