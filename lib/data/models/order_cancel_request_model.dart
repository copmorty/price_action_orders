import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';

class CancelOrderRequestModel extends CancelOrderRequest {
  CancelOrderRequestModel({
    @required String symbol,
    int orderId,
    String origClientOrderId,
    String newClientOrderId,
    int recvWindow,
    int timestamp,
  }) : super(
          symbol: symbol,
          orderId: orderId,
          origClientOrderId: origClientOrderId,
          newClientOrderId: newClientOrderId,
          recvWindow: recvWindow,
          timestamp: timestamp,
        );
  factory CancelOrderRequestModel.fromCancelOrderRequest(CancelOrderRequest cancelOrderRequest) {
    return CancelOrderRequestModel(
      symbol: cancelOrderRequest.symbol,
      orderId: cancelOrderRequest.orderId,
      origClientOrderId: cancelOrderRequest.origClientOrderId,
      newClientOrderId: cancelOrderRequest.newClientOrderId,
      recvWindow: cancelOrderRequest.recvWindow,
      timestamp: cancelOrderRequest.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'orderId': orderId.toString(),
      'origClientOrderId': origClientOrderId,
      'newClientOrderId': newClientOrderId,
      'recvWindow': recvWindow.toString(),
      'timestamp': timestamp.toString(),
    }..removeWhere((key, value) => value == null || value == 'null');
  }
}
