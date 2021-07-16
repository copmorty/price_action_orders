import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'userdata_payload.dart';

class UserDataPayloadOrderUpdate extends UserDataPayload {
  final String/*!*/ symbol;
  final String/*!*/ clientOrderId;
  final BinanceOrderSide/*!*/ side;
  final BinanceOrderType/*!*/ orderType;
  final BinanceOrderTimeInForce/*!*/ timeInForce;
  final Decimal/*!*/ orderQuantity;
  final Decimal/*!*/ orderPrice;
  final Decimal/*!*/ stopPrice;
  final Decimal/*!*/ icebergQuantity;
  final int/*!*/ orderListId;
  final String/*!*/ originalClientOrderId;
  final BinanceOrderExecutionType/*!*/ currentExecutionType;
  final BinanceOrderStatus/*!*/ currentOrderStatus;
  final String/*!*/ orderRejectReason;
  final int/*!*/ orderId;
  final Decimal/*!*/ lastExecutedQuantity;
  final Decimal/*!*/ cumulativeFilledQuantity;
  final Decimal/*!*/ lastExecutedPrice;
  final Decimal/*!*/ commisionAmount;
  final String/*!*/ commisionAsset;
  final int/*!*/ transactionTime;
  final int/*!*/ tradeId;
  // final int ignore;//"I"
  final bool/*!*/ orderIsOnTheBook;
  final bool/*!*/ tradeIsTheMakerSide;
  // final bool ignore;//"M"
  final int/*!*/ orderCreationTime;
  final Decimal/*!*/ cumulativeQuoteAssetTransactedQuantity;
  final Decimal/*!*/ lastQuoteAssetTransactedQuantity;
  final Decimal/*!*/ quoteOrderQuantity;

  UserDataPayloadOrderUpdate({
    BinanceUserDataPayloadEventType/*!*/ eventType,
    int/*!*/ eventTime,
    this.symbol,
    this.clientOrderId,
    this.side,
    this.orderType,
    this.timeInForce,
    this.orderQuantity,
    this.orderPrice,
    this.stopPrice,
    this.icebergQuantity,
    this.orderListId,
    this.originalClientOrderId,
    this.currentExecutionType,
    this.currentOrderStatus,
    this.orderRejectReason,
    this.orderId,
    this.lastExecutedQuantity,
    this.cumulativeFilledQuantity,
    this.lastExecutedPrice,
    this.commisionAmount,
    this.commisionAsset,
    this.transactionTime,
    this.tradeId,
    this.orderIsOnTheBook,
    this.tradeIsTheMakerSide,
    this.orderCreationTime,
    this.cumulativeQuoteAssetTransactedQuantity,
    this.lastQuoteAssetTransactedQuantity,
    this.quoteOrderQuantity,
  }) : super(eventType: eventType, eventTime: eventTime);

  @override
  List<Object> get props => super.props..addAll([symbol, orderId]);
}
