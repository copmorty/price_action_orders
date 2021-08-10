import 'package:collection/collection.dart' show IterableExtension;
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/exchange_info.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/usecases/get_user_last_ticker.dart';
import 'package:price_action_orders/domain/usecases/set_user_last_ticker.dart';
import 'package:price_action_orders/presentation/logic/exchangeinfo_state_notifier.dart';

part 'ticker_state.dart';

class TickerNotifier extends StateNotifier<TickerState> {
  final GetLastTicker _getLastTicker;
  final SetLastTicker _setLastTicker;
  final ExchangeInfoNotifier _exchangeInfoNotifier;

  TickerNotifier({
    required GetLastTicker getLastTicker,
    required SetLastTicker setLastTicker,
    required ExchangeInfoNotifier exchangeInfoNotifier,
    bool init = true,
  })  : _getLastTicker = getLastTicker,
        _setLastTicker = setLastTicker,
        _exchangeInfoNotifier = exchangeInfoNotifier,
        super(TickerInitial()) {
    if (init) initialization();
  }

  Future<void> initialization() async {
    final failureOrTicker = await _getLastTicker(NoParams());
    failureOrTicker.fold(
      (failure) => null, // No ticker cached yet
      (ticker) => setTicker(ticker, init: true),
    );
  }

  Future<bool> setTicker(Ticker ticker, {bool init = false}) async {
    final TickerState oldState = state;
    state = TickerLoading();

    final exchangeInfo = await _exchangeInfoNotifier.getExchangeInfo();

    return exchangeInfo.fold(
      (failure) {
        state = oldState;
        return false;
      },
      (exchangeInfo) {
        final tickerFound = _setTickerDecimalDigits(exchangeInfo, ticker);

        if (tickerFound) {
          if (!init) _setLastTicker(Params(ticker));
          state = TickerLoaded(ticker);
          return true;
        } else {
          state = oldState;
          return false;
        }
      },
    );
  }

  /// If the ticker is found in exchangeInfo, it sets the related global variables and returns true. 
  /// Otherwise, the function returns false.
  bool _setTickerDecimalDigits(ExchangeInfo exchangeInfo, Ticker ticker) {
    final exchangeSymbolInfo =
        exchangeInfo.symbols.firstWhereOrNull((element) => element.symbol.toLowerCase() == (ticker.baseAsset + ticker.quoteAsset).toLowerCase());

    if (exchangeSymbolInfo == null)
      return false;
    else {
      final priceFilterMap = exchangeSymbolInfo.filters.firstWhere((element) => element['filterType'] == 'PRICE_FILTER');
      final lotSizeMap = exchangeSymbolInfo.filters.firstWhere((element) => element['filterType'] == 'LOT_SIZE');
      final tickSize = Decimal.tryParse(priceFilterMap['tickSize']);
      final stepSize = Decimal.tryParse(lotSizeMap['stepSize']);

      currentTickerPriceDecimalDigits = tickSize?.scale ?? currentTickerPriceDecimalDigits;
      currentTickerBaseVolumeDecimalDigits = stepSize?.scale ?? currentTickerBaseVolumeDecimalDigits;

      return true;
    }
  }
}
