import 'package:collection/collection.dart' show IterableExtension;
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';

class CancelOrderResponseModel extends CancelOrderResponse {
  CancelOrderResponseModel({
    required String symbol,
    required String origClientOrderId,
    required int orderId,
    required int orderListId,
    required String clientOrderId,
    required Decimal price,
    required Decimal origQty,
    required Decimal executedQty,
    required Decimal cummulativeQuoteQty,
    required BinanceOrderStatus status,
    required BinanceOrderTimeInForce timeInForce,
    required BinanceOrderType type,
    required BinanceOrderSide side,
  }) : super(
          symbol: symbol,
          origClientOrderId: origClientOrderId,
          orderId: orderId,
          orderListId: orderListId,
          clientOrderId: clientOrderId,
          price: price,
          origQty: origQty,
          executedQty: executedQty,
          cummulativeQuoteQty: cummulativeQuoteQty,
          status: status,
          timeInForce: timeInForce,
          type: type,
          side: side,
        );

  factory CancelOrderResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    return CancelOrderResponseModel(
      symbol: parsedJson['symbol'],
      origClientOrderId: parsedJson['origClientOrderId'],
      orderId: parsedJson['orderId'],
      orderListId: parsedJson['orderListId'],
      clientOrderId: parsedJson['clientOrderId'],
      price: Decimal.parse(parsedJson['price']),
      origQty: Decimal.parse(parsedJson['origQty']),
      executedQty: Decimal.parse(parsedJson['executedQty']),
      cummulativeQuoteQty: Decimal.parse(parsedJson['cummulativeQuoteQty']),
      status: BinanceOrderStatus.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['status'])!,
      timeInForce: BinanceOrderTimeInForce.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['timeInForce'])!,
      type: BinanceOrderType.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['type'])!,
      side: BinanceOrderSide.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['side'])!,
    );
  }
}
