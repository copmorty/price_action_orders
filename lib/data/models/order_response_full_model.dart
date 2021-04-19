import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/data/models/order_fill_model.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';

class OrderResponseFullModel extends OrderResponseFull {
  OrderResponseFullModel({
    @required String symbol,
    @required int orderId,
    @required int orderListId,
    @required String clientOrderId,
    @required int transactTime,
    @required Decimal price,
    @required Decimal origQty,
    @required Decimal executedQty,
    @required Decimal cummulativeQuoteQty,
    @required BinanceOrderStatus status,
    @required BinanceOrderTimeInForce timeInForce,
    @required BinanceOrderType type,
    @required BinanceOrderSide side,
    @required List<OrderFill> fills,
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
          fills: fills,
        );

  @override
  List<Object> get props => [orderId];

  factory OrderResponseFullModel.fromStringifiedMap(String strMap) {
    final Map data = jsonDecode(strMap);

    var fList = data['fills'] as List;
    List<OrderFill> fillsList = fList.map((item) => OrderFillModel.fromJsonStream(item)).toList();

    return OrderResponseFullModel(
      symbol: data['symbol'],
      orderId: data['orderId'],
      orderListId: data['orderListId'],
      clientOrderId: data['clientOrderId'],
      transactTime: data['transactTime'],
      price: Decimal.parse(data['price']),
      origQty: Decimal.parse(data['origQty']),
      executedQty: Decimal.parse(data['executedQty']),
      cummulativeQuoteQty: Decimal.parse(data['cummulativeQuoteQty']),
      status: BinanceOrderStatus.values.firstWhere((enumElement) => enumElement.toShortString() == data['status'], orElse: () => null),
      timeInForce: BinanceOrderTimeInForce.values.firstWhere((enumElement) => enumElement.toShortString() == data['timeInForce'], orElse: () => null),
      type: BinanceOrderType.values.firstWhere((enumElement) => enumElement.toShortString() == data['type'], orElse: () => null),
      side: BinanceOrderSide.values.firstWhere((enumElement) => enumElement.toShortString() == data['side'], orElse: () => null),
      fills: fillsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'orderId': orderId,
      'orderListId': orderListId,
      'clientOrderId': clientOrderId,
      'transactTime': transactTime,
      'price': price,
      'origQty': origQty,
      'executedQty': executedQty,
      'cummulativeQuoteQty': cummulativeQuoteQty,
      'status': status,
      'timeInForce': timeInForce,
      'type': type,
      'side': side,
      'fills': fills,
    };
  }
}
