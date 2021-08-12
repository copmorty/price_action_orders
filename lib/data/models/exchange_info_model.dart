import 'package:price_action_orders/data/models/exchange_symbol_info_model.dart';
import 'package:price_action_orders/domain/entities/exchange_info.dart';
import 'package:price_action_orders/domain/entities/exchange_symbol_info.dart';

class ExchangeInfoModel extends ExchangeInfo {
  ExchangeInfoModel({
    required String timezone,
    required int serverTime,
    required List<Map<String, dynamic>> rateLimits,
    required List<Map<String, dynamic>> exchangeFilters,
    required List<ExchangeSymbolInfo> symbols,
  }) : super(
          timezone: timezone,
          serverTime: serverTime,
          rateLimits: rateLimits,
          exchangeFilters: exchangeFilters,
          symbols: symbols,
        );

  @override
  List<Object> get props => [timezone, serverTime];

  factory ExchangeInfoModel.fromJson(Map<String, dynamic> json) {
    final sList = json['symbols'] as List;
    List<ExchangeSymbolInfoModel> symbolsList = sList.map((symbolMap) => ExchangeSymbolInfoModel.fromJson(symbolMap)).toList();

    return ExchangeInfoModel(
      timezone: json['timezone'],
      serverTime: json['serverTime'],
      rateLimits: List<Map<String, dynamic>>.from(json['rateLimits']),
      exchangeFilters: List<Map<String, dynamic>>.from(json['exchangeFilters']),
      symbols: symbolsList,
    );
  }
}
