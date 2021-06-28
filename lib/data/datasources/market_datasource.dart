import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocket;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/constants.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/utils/datasource_utils.dart';
import 'package:price_action_orders/data/models/bookticker_model.dart';
import 'package:price_action_orders/data/models/ticker_model.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';

abstract class MarketDataSource {
  Future<Stream<BookTicker>> getBookTickerStream(Ticker ticker);
  Future<void> cacheLastTicker(Ticker ticker);
  Future<Ticker> getLastTicker();
}

class MarketDataSourceImpl implements MarketDataSource {
  final SharedPreferences sharedPreferences;
  final DataSourceUtils dataSourceUtils;
  WebSocket _webSocket;
  StreamController<BookTicker> _streamController;

  MarketDataSourceImpl({
    @required this.sharedPreferences,
    @required this.dataSourceUtils,
  });

  @override
  Future<Stream<BookTicker>> getBookTickerStream(Ticker ticker) async {
    const pathWS = '/ws/';

    final String symbol = ticker.baseAsset + ticker.quoteAsset;
    String pair = symbol.toLowerCase().replaceAll(RegExp(r'/'), '');

    _webSocket?.close();
    _streamController?.close();
    _streamController = StreamController<BookTicker>();

    try {
      _webSocket = await dataSourceUtils.webSocketConnect(binanceWebSocketUrl + pathWS + '$pair@bookTicker');

      if (_webSocket.readyState == WebSocket.open) {
        _webSocket.listen(
          (data) {
            final jsonData = jsonDecode(data);
            final bookTickerModel = BookTickerModel.fromJson(jsonData, ticker);
            _streamController.add(bookTickerModel);
          },
          onDone: () => print('[+] BookTicker stream done.'),
          onError: (err) => print('[!] Error: ${err.toString()}'),
          cancelOnError: true,
        );
      } else {
        print('[!] Connection denied.');
      }
    } catch (err) {
      _webSocket?.close();
      _streamController.close();
      throw ServerException(message: "Could not obtain BookTicker stream.");
    }

    return _streamController.stream;
  }

  @override
  Future<void> cacheLastTicker(Ticker ticker) {
    final tickerModel = TickerModel.fromTicker(ticker);
    return sharedPreferences.setString(
      LAST_TICKER,
      jsonEncode(tickerModel.toJson()),
    );
  }

  @override
  Future<Ticker> getLastTicker() {
    final jsonString = sharedPreferences.getString(LAST_TICKER);
    if (jsonString != null) {
      return Future.value(TickerModel.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
