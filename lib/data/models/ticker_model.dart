import 'package:price_action_orders/domain/entities/ticker.dart';

class TickerModel extends Ticker {
  TickerModel({
    String/*!*/ baseAsset,
    String/*!*/ quoteAsset,
  }) : super(
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
        );

  factory TickerModel.fromTicker(Ticker ticker) {
    return TickerModel(
      baseAsset: ticker.baseAsset,
      quoteAsset: ticker.quoteAsset,
    );
  }

  factory TickerModel.fromJson(Map<String, dynamic> json) {
    return TickerModel(
      baseAsset: json['baseAsset'],
      quoteAsset: json['quoteAsset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'baseAsset': baseAsset,
      'quoteAsset': quoteAsset,
    };
  }
}
