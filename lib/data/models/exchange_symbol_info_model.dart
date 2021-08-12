import 'package:collection/collection.dart' show IterableExtension;
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/exchange_symbol_info.dart';

class ExchangeSymbolInfoModel extends ExchangeSymbolInfo {
  ExchangeSymbolInfoModel({
    required String symbol,
    required String status,
    required String baseAsset,
    required int baseAssetPrecision,
    required String quoteAsset,
    required int quotePrecision,
    required int quoteAssetPrecision,
    required int baseCommissionPrecision,
    required int quoteCommissionPrecision,
    required List<BinanceOrderType> orderTypes,
    required bool icebergAllowed,
    required bool ocoAllowed,
    required bool quoteOrderQtyMarketAllowed,
    required bool isSpotTradingAllowed,
    required bool isMarginTradingAllowed,
    required List<Map<String, dynamic>> filters,
    required List<String> permissions,
  }) : super(
          symbol: symbol,
          status: status,
          baseAsset: baseAsset,
          baseAssetPrecision: baseAssetPrecision,
          quoteAsset: quoteAsset,
          quotePrecision: quotePrecision,
          quoteAssetPrecision: quoteAssetPrecision,
          baseCommissionPrecision: baseCommissionPrecision,
          quoteCommissionPrecision: quoteCommissionPrecision,
          orderTypes: orderTypes,
          icebergAllowed: icebergAllowed,
          ocoAllowed: ocoAllowed,
          quoteOrderQtyMarketAllowed: quoteOrderQtyMarketAllowed,
          isSpotTradingAllowed: isSpotTradingAllowed,
          isMarginTradingAllowed: isMarginTradingAllowed,
          filters: filters,
          permissions: permissions,
        );

  factory ExchangeSymbolInfoModel.fromJson(Map<String, dynamic> json) {
    final oList = json['orderTypes'] as List;
    final List<BinanceOrderType> orderTypesList =
        oList.map((orderType) => BinanceOrderType.values.firstWhereOrNull((enumElement) => enumElement.toShortString() == orderType)!).toList();

    return ExchangeSymbolInfoModel(
      symbol: json['symbol'],
      status: json['status'],
      baseAsset: json['baseAsset'],
      baseAssetPrecision: json['baseAssetPrecision'],
      quoteAsset: json['quoteAsset'],
      quotePrecision: json['quotePrecision'],
      quoteAssetPrecision: json['quoteAssetPrecision'],
      baseCommissionPrecision: json['baseCommissionPrecision'],
      quoteCommissionPrecision: json['quoteAssetPrecision'],
      orderTypes: orderTypesList,
      icebergAllowed: json['icebergAllowed'],
      ocoAllowed: json['ocoAllowed'],
      quoteOrderQtyMarketAllowed: json['quoteOrderQtyMarketAllowed'],
      isSpotTradingAllowed: json['isSpotTradingAllowed'],
      isMarginTradingAllowed: json['isMarginTradingAllowed'],
      filters: List<Map<String, dynamic>>.from(json['filters']),
      permissions: List<String>.from(json['permissions']),
    );
  }
}
