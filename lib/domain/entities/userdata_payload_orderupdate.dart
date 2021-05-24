import 'package:meta/meta.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'userdata_payload.dart';

class UserDataPayloadOrderUpdate extends UserDataPayload {
  final String symbol;
  final String clientOrderId;
  final BinanceOrderSide side;
  final BinanceOrderType orderType;
  final BinanceOrderTimeInForce timeInForce;
  final Decimal orderQuantity;
  final Decimal orderPrice;
  final Decimal stopPrice;
  final Decimal icebergQuantity;
  final int orderListId;
  final String originalClientOrderId;
  final BinanceOrderExecutionType currentExecutionType;
  final BinanceOrderStatus currentOrderStatus;
  final String orderRejectReason;
  final int orderId;
  final Decimal lastExecutedQuantity;
  final Decimal cumulativeFilledQuantity;
  final Decimal lastExecutedPrice;
  final Decimal commisionAmount;
  final String commisionAsset;
  final int transactionTime;
  final int tradeId;
  // final int ignore;//"I"
  final bool orderIsOnTheBook;
  final bool tradeIsTheMakerSide;
  // final bool ignore;//"M"
  final int orderCreationTime;
  final Decimal cumulativeQuoteAssetTransactedQuantity;
  final Decimal lastQuoteAssetTransactedQuantity;
  final Decimal quoteOrderQuantity;

  UserDataPayloadOrderUpdate({
    @required BinanceUserDataPayloadEventType eventType,
    @required int eventTime,
    @required this.symbol,
    @required this.clientOrderId,
    @required this.side,
    @required this.orderType,
    @required this.timeInForce,
    @required this.orderQuantity,
    @required this.orderPrice,
    @required this.stopPrice,
    @required this.icebergQuantity,
    @required this.orderListId,
    @required this.originalClientOrderId,
    @required this.currentExecutionType,
    @required this.currentOrderStatus,
    @required this.orderRejectReason,
    @required this.orderId,
    @required this.lastExecutedQuantity,
    @required this.cumulativeFilledQuantity,
    @required this.lastExecutedPrice,
    @required this.commisionAmount,
    @required this.commisionAsset,
    @required this.transactionTime,
    @required this.tradeId,
    @required this.orderIsOnTheBook,
    @required this.tradeIsTheMakerSide,
    @required this.orderCreationTime,
    @required this.cumulativeQuoteAssetTransactedQuantity,
    @required this.lastQuoteAssetTransactedQuantity,
    @required this.quoteOrderQuantity,
  }) : super(eventType: eventType, eventTime: eventTime);

  @override
  List<Object> get props => [];
}
