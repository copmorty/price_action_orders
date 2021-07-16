import 'package:equatable/equatable.dart';

class CancelOrderRequest extends Equatable {
  /// Creates a cancel order request.
  ///
  /// The [orderId] or the [origClientOrderId] must be provided,
  /// not both and not neither.
  final String/*!*/ symbol;
  final int orderId;
  final String origClientOrderId;
  final String newClientOrderId;
  final int recvWindow;
  final int timestamp;

  CancelOrderRequest({
    this.symbol,
    this.orderId,
    this.origClientOrderId,
    this.newClientOrderId,
    this.recvWindow,
    timestamp,
  })  : assert((orderId != null || origClientOrderId != null) && !(orderId == null && origClientOrderId == null)),
        this.timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object> get props => [symbol, orderId];
}
