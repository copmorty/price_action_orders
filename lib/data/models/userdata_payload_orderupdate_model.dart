import 'package:collection/collection.dart' show IterableExtension;
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_orderupdate.dart';

class UserDataPayloadOrderUpdateModel extends UserDataPayloadOrderUpdate {
  UserDataPayloadOrderUpdateModel({
    required BinanceUserDataPayloadEventType eventType,
    required int eventTime,
    required String symbol,
    required String clientOrderId,
    required BinanceOrderSide side,
    required BinanceOrderType orderType,
    required BinanceOrderTimeInForce timeInForce,
    required Decimal orderQuantity,
    required Decimal orderPrice,
    required Decimal stopPrice,
    required Decimal icebergQuantity,
    required int orderListId,
    required String originalClientOrderId,
    required BinanceOrderExecutionType currentExecutionType,
    required BinanceOrderStatus currentOrderStatus,
    required String orderRejectReason,
    required int orderId,
    required Decimal lastExecutedQuantity,
    required Decimal cumulativeFilledQuantity,
    required Decimal lastExecutedPrice,
    required Decimal commisionAmount,
    required String? commisionAsset,
    required int transactionTime,
    required int tradeId,
    // required int ignore,//"I"
    required bool orderIsOnTheBook,
    required bool tradeIsTheMakerSide,
    // required bool ignore,//"M"
    required int orderCreationTime,
    required Decimal cumulativeQuoteAssetTransactedQuantity,
    required Decimal lastQuoteAssetTransactedQuantity,
    required Decimal quoteOrderQuantity,
  }) : super(
          eventType: eventType,
          eventTime: eventTime,
          symbol: symbol,
          clientOrderId: clientOrderId,
          side: side,
          orderType: orderType,
          timeInForce: timeInForce,
          orderQuantity: orderQuantity,
          orderPrice: orderPrice,
          stopPrice: stopPrice,
          icebergQuantity: icebergQuantity,
          orderListId: orderListId,
          originalClientOrderId: originalClientOrderId,
          currentExecutionType: currentExecutionType,
          currentOrderStatus: currentOrderStatus,
          orderRejectReason: orderRejectReason,
          orderId: orderId,
          lastExecutedQuantity: lastExecutedQuantity,
          cumulativeFilledQuantity: cumulativeFilledQuantity,
          lastExecutedPrice: lastExecutedPrice,
          commisionAmount: commisionAmount,
          commisionAsset: commisionAsset,
          transactionTime: transactionTime,
          tradeId: tradeId,
          orderIsOnTheBook: orderIsOnTheBook,
          tradeIsTheMakerSide: tradeIsTheMakerSide,
          orderCreationTime: orderCreationTime,
          cumulativeQuoteAssetTransactedQuantity: cumulativeQuoteAssetTransactedQuantity,
          lastQuoteAssetTransactedQuantity: lastQuoteAssetTransactedQuantity,
          quoteOrderQuantity: quoteOrderQuantity,
        );

  factory UserDataPayloadOrderUpdateModel.fromJson(Map<String, dynamic> parsedJson) {
    return UserDataPayloadOrderUpdateModel(
      eventType: BinanceUserDataPayloadEventType.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['e'])!,
      eventTime: parsedJson['E'],
      symbol: parsedJson['s'],
      clientOrderId: parsedJson['c'],
      side: BinanceOrderSide.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['S'])!,
      orderType: BinanceOrderType.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['o'])!,
      timeInForce: BinanceOrderTimeInForce.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['f'])!,
      orderQuantity: Decimal.parse(parsedJson['q']),
      orderPrice: Decimal.parse(parsedJson['p']),
      stopPrice: Decimal.parse(parsedJson['P']),
      icebergQuantity: Decimal.parse(parsedJson['F']),
      orderListId: parsedJson['g'],
      originalClientOrderId: parsedJson['C'],
      currentExecutionType: BinanceOrderExecutionType.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['x'])!,
      currentOrderStatus: BinanceOrderStatus.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == parsedJson['X'])!,
      orderRejectReason: parsedJson['r'],
      orderId: parsedJson['i'],
      lastExecutedQuantity: Decimal.parse(parsedJson['l']),
      cumulativeFilledQuantity: Decimal.parse(parsedJson['z']),
      lastExecutedPrice: Decimal.parse(parsedJson['L']),
      commisionAmount: Decimal.parse(parsedJson['n']),
      commisionAsset: parsedJson['N'],
      transactionTime: parsedJson['T'],
      tradeId: parsedJson['t'],
      orderIsOnTheBook: parsedJson['w'],
      tradeIsTheMakerSide: parsedJson['m'],
      orderCreationTime: parsedJson['O'],
      cumulativeQuoteAssetTransactedQuantity: Decimal.parse(parsedJson['Z']),
      lastQuoteAssetTransactedQuantity: Decimal.parse(parsedJson['Y']),
      quoteOrderQuantity: Decimal.parse(parsedJson['Q']),
    );
  }
}
