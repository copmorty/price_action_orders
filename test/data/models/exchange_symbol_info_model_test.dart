import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/exchange_symbol_info_model.dart';
import 'package:price_action_orders/domain/entities/exchange_symbol_info.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tExchangeSymbolInfoModel = ExchangeSymbolInfoModel(
    symbol: 'ETHBTC',
    status: 'TRADING',
    baseAsset: 'ETH',
    baseAssetPrecision: 8,
    quoteAsset: 'BTC',
    quotePrecision: 8,
    quoteAssetPrecision: 8,
    baseCommissionPrecision: 8,
    quoteCommissionPrecision: 8,
    orderTypes: [
      BinanceOrderType.LIMIT,
      BinanceOrderType.LIMIT_MAKER,
      BinanceOrderType.MARKET,
      BinanceOrderType.STOP_LOSS_LIMIT,
      BinanceOrderType.TAKE_PROFIT_LIMIT,
    ],
    icebergAllowed: true,
    ocoAllowed: true,
    quoteOrderQtyMarketAllowed: true,
    isSpotTradingAllowed: true,
    isMarginTradingAllowed: true,
    filters: [
      {"filterType": "PRICE_FILTER", "minPrice": "0.00000100", "maxPrice": "922327.00000000", "tickSize": "0.00000100"},
      {"filterType": "PERCENT_PRICE", "multiplierUp": "5", "multiplierDown": "0.2", "avgPriceMins": 5},
      {"filterType": "LOT_SIZE", "minQty": "0.00100000", "maxQty": "100000.00000000", "stepSize": "0.00100000"},
      {"filterType": "MIN_NOTIONAL", "minNotional": "0.00010000", "applyToMarket": true, "avgPriceMins": 5},
      {"filterType": "ICEBERG_PARTS", "limit": 10},
      {"filterType": "MARKET_LOT_SIZE", "minQty": "0.00000000", "maxQty": "1041.49940653", "stepSize": "0.00000000"},
      {"filterType": "MAX_NUM_ORDERS", "maxNumOrders": 200},
      {"filterType": "MAX_NUM_ALGO_ORDERS", "maxNumAlgoOrders": 5},
    ],
    permissions: ['SPOT', 'MARGIN'],
  );

  test(
    'should be a subclass of ExchangeSymbolInfo',
    () async {
      //assert
      expect(tExchangeSymbolInfoModel, isA<ExchangeSymbolInfo>());
    },
  );

  test(
    'fromJson should return a valid ExchangeSymbolInfoModel',
    () async {
      //arrange
      final parsedJson = jsonDecode(attachment('exchange_symbol_info.json'));
      //act
      final result = ExchangeSymbolInfoModel.fromJson(parsedJson);
      //assert
      expect(result, tExchangeSymbolInfoModel);
    },
  );
}
