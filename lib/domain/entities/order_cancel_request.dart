import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class CancelOrderRequest extends Equatable {
  final String symbol;
  final int orderId;
  final String origClientOrderId;
  final String newClientOrderId;
  final int recvWindow;
  final int timestamp;

  CancelOrderRequest({
    @required this.symbol,
    this.orderId,
    this.origClientOrderId,
    this.newClientOrderId,
    this.recvWindow,
    timestamp,
  })  : assert(orderId != null || origClientOrderId != null),
        this.timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [symbol, orderId];
}
