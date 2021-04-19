import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocket;
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/constants.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/data/models/bookticker_model.dart';
import 'package:price_action_orders/data/models/ticker_model.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BookTickerDataSource {
  /// Websocket stream
  Future<Stream<BookTicker>> streamBookTicker(Ticker ticker);
  Future<void> cacheLastTicker(Ticker ticker);
  Future<Ticker> getLastTicker();
}

class BookTickerDataSourceImpl implements BookTickerDataSource {
  final SharedPreferences sharedPreferences;
  WebSocket _webSocket;
  StreamController<BookTicker> _streamController;

  BookTickerDataSourceImpl(this.sharedPreferences);

  @override
  Future<Stream<BookTicker>> streamBookTicker(ticker) async {
    const pathWS = '/ws/';
    final String symbol = ticker.baseAsset + ticker.quoteAsset;
    String pair = symbol.toLowerCase().replaceAll(RegExp(r'/'), '');

    _webSocket?.close();
    _streamController?.close();
    _streamController = StreamController<BookTicker>();

    try {
      _webSocket = await WebSocket.connect(binanceTestWebSocketUrl + pathWS + '$pair@bookTicker');
      if (_webSocket.readyState == WebSocket.open) {
        _webSocket.listen(
          (data) {
            final bookTickerModel = BookTickerModel.fromStringifiedMap(strMap: data, ticker: ticker);
            _streamController.add(bookTickerModel);
          },
          onDone: () => print('[+]Done :)'),
          onError: (err) => print('[!]Error -- ${err.toString()}'),
          cancelOnError: true,
        );
      } else {
        print('[!]Connection Denied');
      }
    } catch (err) {
      print(err);
      _streamController.close();
      throw ServerException();
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
      return Future.value(TickerModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
