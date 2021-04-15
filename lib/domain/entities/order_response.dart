import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class OrderResponse extends Equatable {
  final String symbol;
  final int orderId;
  final int orderListId;
  final String clientOrderId;
  final int transactTime;

  OrderResponse({
    @required this.symbol,
    @required this.orderId,
    @required this.orderListId,
    @required this.clientOrderId,
    @required this.transactTime,
  });

  @override
  List<Object> get props => [orderId];
}
