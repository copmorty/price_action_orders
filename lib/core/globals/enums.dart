import 'package:price_action_orders/core/utils/enum_functions.dart';

enum AppMode { TEST, PRODUCTION }
enum BinanceOrderSide { BUY, SELL }
enum BinanceOrderType { LIMIT, MARKET, STOP_LOSS, STOP_LOSS_LIMIT, TAKE_PROFIT, TAKE_PROFIT_LIMIT, LIMIT_MAKER }
enum BinanceOrderStatus { NEW, PARTIALLY_FILLED, FILLED, CANCELED, PENDING_CANCEL, REJECTED, EXPIRED }
enum BinanceOrderTimeInForce { GTC, IOC, FOK }
enum BinanceOrderResponseType { ACK, RESULT, FULL }
enum BinanceOrderExecutionType { NEW, CANCELED, REPLACED, REJECTED, TRADE, EXPIRED }
enum BinanceUserDataPayloadEventType { outboundAccountPosition, balanceUpdate, executionReport, listStatus }

extension AppModeExtension on AppMode {
  String toShortString() => enumToShortString(this);
}

extension BinanceOrderSideExtension on BinanceOrderSide {
  String toShortString() => enumToShortString(this);
  String capitalize() => enumToCapitalizedSentenceString(this);
}

extension BinanceOrderTypeExtension on BinanceOrderType {
  String toShortString() => enumToShortString(this);
  String capitalizeWords() => enumToCapitalizedWordsString(this);
}

extension BinanceOrderStatusExtension on BinanceOrderStatus {
  String toShortString() => enumToShortString(this);
  String capitalizeWords() => enumToCapitalizedWordsString(this);
  String capitalizeCharacters() => enumToCapitalizedCharactersString(this);
}

extension BinanceOrderTimeInForceExtension on BinanceOrderTimeInForce {
  String toShortString() => enumToShortString(this);
}

extension BinanceOrderResponseTypeExtension on BinanceOrderResponseType {
  String toShortString() => enumToShortString(this);
}

extension BinanceOrderExecutionTypeExtension on BinanceOrderExecutionType {
  String toShortString() => enumToShortString(this);
}

extension BinanceUserDataPayloadEventTypeExtension on BinanceUserDataPayloadEventType {
  String toShortString() => enumToShortString(this);
}
