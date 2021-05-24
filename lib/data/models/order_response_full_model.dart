import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/order_fill_model.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

class OrderResponseFullModel extends OrderResponseFull {
  OrderResponseFullModel({
    @required Ticker ticker,
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
          ticker: ticker,
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

  factory OrderResponseFullModel.fromJson(Map<String, dynamic> parsedJson, Ticker ticker) {

    var fList = parsedJson['fills'] as List;
    List<OrderFill> fillsList = fList.map((item) => OrderFillModel.fromJsonStream(item)).toList();

    return OrderResponseFullModel(
      ticker: ticker,
      symbol: parsedJson['symbol'],
      orderId: parsedJson['orderId'],
      orderListId: parsedJson['orderListId'],
      clientOrderId: parsedJson['clientOrderId'],
      transactTime: parsedJson['transactTime'],
      price: Decimal.parse(parsedJson['price']),
      origQty: Decimal.parse(parsedJson['origQty']),
      executedQty: Decimal.parse(parsedJson['executedQty']),
      cummulativeQuoteQty: Decimal.parse(parsedJson['cummulativeQuoteQty']),
      status: BinanceOrderStatus.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['status'], orElse: () => null),
      timeInForce: BinanceOrderTimeInForce.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['timeInForce'], orElse: () => null),
      type: BinanceOrderType.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['type'], orElse: () => null),
      side: BinanceOrderSide.values.firstWhere((enumElement) => enumElement.toShortString() == parsedJson['side'], orElse: () => null),
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
