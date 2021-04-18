enum BinanceOrderSide { BUY, SELL }
enum BinanceOrderType { LIMIT, MARKET, STOP_LOSS, STOP_LOSS_LIMIT, TAKE_PROFIT, TAKE_PROFIT_LIMIT, LIMIT_MAKER }
enum BinanceOrderStatus { NEW, PARTIALLY_FILLED, FILLED, CANCELED, PENDING_CANCEL, REJECTED, EXPIRED }
enum BinanceOrderTimeInForce { GTC, IOC, FOK }
enum BinanceOrderResponseType { ACK, RESULT, FULL }

extension BinanceOrderSideExtension on BinanceOrderSide {
  String toShortString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
    // return this.toString().split('.').last;
  }
}

extension BinanceOrderTypeExtension on BinanceOrderType {
  String toShortString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}

extension BinanceOrderStatusExtension on BinanceOrderStatus {
  String toShortString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}

extension BinanceOrderTimeInForceExtension on BinanceOrderTimeInForce {
  String toShortString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}

extension BinanceOrderResponseTypeExtension on BinanceOrderResponseType {
  String toShortString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
