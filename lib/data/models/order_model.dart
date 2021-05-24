import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order.dart';

class OrderModel extends Order {
  OrderModel({
    @required String symbol,
    @required int orderId,
    @required int orderListId,
    @required String clientOrderId,
    @required Decimal price,
    @required Decimal origQty,
    @required Decimal executedQty,
    @required Decimal cummulativeQuoteQty,
    @required BinanceOrderStatus status,
    @required BinanceOrderTimeInForce timeInForce,
    @required BinanceOrderType type,
    @required BinanceOrderSide side,
    @required Decimal stopPrice,
    @required Decimal icebergQty,
    @required int time,
    @required int updateTime,
    @required bool isWorking,
    @required Decimal origQuoteOrderQty,
  }) : super(
          symbol: symbol,
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
          stopPrice: stopPrice,
          icebergQty: icebergQty,
          time: time,
          updateTime: updateTime,
          isWorking: isWorking,
          origQuoteOrderQty: origQuoteOrderQty,
        );

  factory OrderModel.fromJson(Map<String, dynamic> parsedJson) {
    return OrderModel(
      symbol: parsedJson['symbol'],
      orderId: parsedJson['orderId'],
      orderListId: parsedJson['orderListId'],
      clientOrderId: parsedJson['clientOrderId'],
      price: Decimal.parse(parsedJson['price']),
      origQty: Decimal.parse(parsedJson['origQty']),
      executedQty: Decimal.parse(parsedJson['executedQty']),
      cummulativeQuoteQty: Decimal.parse(parsedJson['cummulativeQuoteQty']),
      status: BinanceOrderStatus.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['status'], orElse: () => null),
      timeInForce:
          BinanceOrderTimeInForce.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['timeInForce'], orElse: () => null),
      type: BinanceOrderType.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['type'], orElse: () => null),
      side: BinanceOrderSide.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['side'], orElse: () => null),
      stopPrice: Decimal.parse(parsedJson['stopPrice']),
      icebergQty: Decimal.parse(parsedJson['icebergQty']),
      time: parsedJson['time'],
      updateTime: parsedJson['updateTime'],
      isWorking: parsedJson['isWorking'],
      origQuoteOrderQty: Decimal.parse(parsedJson['origQuoteOrderQty']),
    );
  }
}
