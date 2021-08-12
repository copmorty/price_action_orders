import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/data/models/exchange_info_model.dart';
import 'package:price_action_orders/data/models/exchange_symbol_info_model.dart';
import 'package:price_action_orders/domain/entities/exchange_info.dart';
import '../../attachments/attachment_reader.dart';

final _exchangeSymbolInfoModel = ExchangeSymbolInfoModel(
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

void main() {
  final tExchangeInfoModel = ExchangeInfoModel(
    timezone: 'UTC',
    serverTime: 1628692692594,
    rateLimits: [
      {"rateLimitType": "REQUEST_WEIGHT", "interval": "MINUTE", "intervalNum": 1, "limit": 1200},
      {"rateLimitType": "ORDERS", "interval": "SECOND", "intervalNum": 10, "limit": 50},
      {"rateLimitType": "ORDERS", "interval": "DAY", "intervalNum": 1, "limit": 160000},
      {"rateLimitType": "RAW_REQUESTS", "interval": "MINUTE", "intervalNum": 5, "limit": 6100},
    ],
    exchangeFilters: [],
    symbols: [_exchangeSymbolInfoModel],
  );

  test(
    'should be a subclass of ExchangeInfo',
    () async {
      //assert
      expect(tExchangeInfoModel, isA<ExchangeInfo>());
    },
  );

  test(
    'fromJson should return a valid ExchangeInfoModel',
    () async {
      //arrange
      final parsedJson = jsonDecode(attachment('exchange_info.json'));
      //act
      final result = ExchangeInfoModel.fromJson(parsedJson);
      //assert
      expect(result, tExchangeInfoModel);
    },
  );
}
