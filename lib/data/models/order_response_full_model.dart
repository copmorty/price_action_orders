import 'dart:convert';

import 'package:price_action_orders/core/globals/enums.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';

class OrderResponseFullModel extends OrderResponseFull {
  // final List<Fill> fills;

  OrderResponseFullModel({
    @required String symbol,
    @required int orderId,
    @required int orderListId,
    @required String clientOrderId,
    @required int transactTime,
    @required String price,
    @required String origQty,
    @required String executedQty,
    @required String cummulativeQuoteQty,
    @required BinanceOrderStatus status,
    @required BinanceOrderTimeInForce timeInForce,
    @required BinanceOrderType type,
    @required BinanceOrderSide side,
  }) : super(
          symbol: symbol,
          orderId: orderId,
          orderListId: orderListId,
          clientOrderId: clientOrderId,
          transactTime: transactTime,
          price: price,
          origQty: origQty,
          executedQty: executedQty,
          cummulativeQuoteQty: cummulativeQuoteQty,
          status: status,
          timeInForce: timeInForce,
          type: type,
          side: side,
        );

  @override
  List<Object> get props => [orderId];

  factory OrderResponseFullModel.fromStringifiedMap(String strMap) {
    final Map data = jsonDecode(strMap);

    return OrderResponseFullModel(
      symbol: data['symbol'],
      orderId: data['orderId'],
      orderListId: data['orderListId'],
      clientOrderId: data['clientOrderId'],
      transactTime: data['transactTime'],
      price: data['price'],
      origQty: data['origQty'],
      executedQty: data['executedQty'],
      cummulativeQuoteQty: data['cummulativeQuoteQty'],
      status: BinanceOrderStatus.values.firstWhere((enumElement) => enumElement.toShortString() == data['status'], orElse: () => null),
      timeInForce: BinanceOrderTimeInForce.values.firstWhere((enumElement) => enumElement.toShortString() == data['timeInForce'], orElse: () => null),
      type: BinanceOrderType.values.firstWhere((enumElement) => enumElement.toShortString() == data['type'], orElse: () => null),
      side: BinanceOrderSide.values.firstWhere((enumElement) => enumElement.toShortString() == data['side'], orElse: () => null),
    );
  }
}
