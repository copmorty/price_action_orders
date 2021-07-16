import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';

class CancelOrderResponseModel extends CancelOrderResponse {
  CancelOrderResponseModel({
    String/*!*/ symbol,
    String/*!*/ origClientOrderId,
    int/*!*/ orderId,
    int/*!*/ orderListId,
    String/*!*/ clientOrderId,
    Decimal/*!*/ price,
    Decimal/*!*/ origQty,
    Decimal/*!*/ executedQty,
    Decimal/*!*/ cummulativeQuoteQty,
    BinanceOrderStatus/*!*/ status,
    BinanceOrderTimeInForce/*!*/ timeInForce,
    BinanceOrderType/*!*/ type,
    BinanceOrderSide/*!*/ side,
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
      status: BinanceOrderStatus.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['status'], orElse: () => null),
      timeInForce: BinanceOrderTimeInForce.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['timeInForce'], orElse: () => null),
      type: BinanceOrderType.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['type'], orElse: () => null),
      side: BinanceOrderSide.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['side'], orElse: () => null),
    );
  }
}
