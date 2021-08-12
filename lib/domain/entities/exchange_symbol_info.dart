import 'package:equatable/equatable.dart';
import 'package:price_action_orders/core/globals/enums.dart';

class ExchangeSymbolInfo extends Equatable {
  final String symbol;
  final String status;
  final String baseAsset;
  final int baseAssetPrecision;
  final String quoteAsset;
  final int quotePrecision;
  final int quoteAssetPrecision;
  final int baseCommissionPrecision;
  final int quoteCommissionPrecision;
  final List<BinanceOrderType> orderTypes;
  final bool icebergAllowed;
  final bool ocoAllowed;
  final bool quoteOrderQtyMarketAllowed;
  final bool isSpotTradingAllowed;
  final bool isMarginTradingAllowed;
  final List<Map<String, dynamic>> filters;
  final List<String> permissions;

  ExchangeSymbolInfo({
    required this.symbol,
    required this.status,
    required this.baseAsset,
    required this.baseAssetPrecision,
    required this.quoteAsset,
    required this.quotePrecision,
    required this.quoteAssetPrecision,
    required this.baseCommissionPrecision,
    required this.quoteCommissionPrecision,
    required this.orderTypes,
    required this.icebergAllowed,
    required this.ocoAllowed,
    required this.quoteOrderQtyMarketAllowed,
    required this.isSpotTradingAllowed,
    required this.isMarginTradingAllowed,
    required this.filters,
    required this.permissions,
  });

  @override
  List<Object> get props => [symbol];
}
