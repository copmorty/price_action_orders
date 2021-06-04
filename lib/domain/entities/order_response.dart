import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'ticker.dart';

class OrderResponse extends Equatable {
  final Ticker ticker;
  final String symbol;
  final int orderId;
  final int orderListId;
  final String clientOrderId;
  final int transactTime;

  OrderResponse({
    @required this.ticker,
    @required this.symbol,
    @required this.orderId,
    @required this.orderListId,
    @required this.clientOrderId,
    @required this.transactTime,
  });

  @override
  List<Object> get props => [symbol, orderId];
}
