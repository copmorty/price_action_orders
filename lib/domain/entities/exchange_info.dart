import 'package:equatable/equatable.dart';
import 'package:price_action_orders/domain/entities/exchange_symbol_info.dart';

class ExchangeInfo extends Equatable {
  final String timezone;
  final int serverTime;
  final List<Map<String, dynamic>> rateLimits;
  final List<Map<String, dynamic>> exchangeFilters;
  final List<ExchangeSymbolInfo> symbols;

  ExchangeInfo({
    required this.timezone,
    required this.serverTime,
    required this.rateLimits,
    required this.exchangeFilters,
    required this.symbols,
  });

  @override
  List<Object> get props => [timezone, serverTime];
}
