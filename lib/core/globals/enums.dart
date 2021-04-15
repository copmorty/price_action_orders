enum BinanceOrderSide { BUY, SELL }
enum BinanceOrderType { LIMIT, MARKET, STOP_LOSS, STOP_LOSS_LIMIT, TAKE_PROFIT, TAKE_PROFIT_LIMIT, LIMIT_MAKER }

extension ParseToString on BinanceOrderSide {
  String toShortString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
    // return this.toString().split('.').last;
  }
}

extension BinanceOrderTypeExtension on BinanceOrderType {
  String toShortString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
    // return this.toString().split('.').last;
  }
}
