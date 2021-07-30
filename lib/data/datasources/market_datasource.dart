import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocket;
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/utils/datasource_utils.dart';
import 'package:price_action_orders/data/models/bookticker_model.dart';
import 'package:price_action_orders/data/models/ticker_model.dart';
import 'package:price_action_orders/data/models/ticker_stats_model.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';

abstract class MarketDataSource {
  Future<Stream<BookTicker>> getBookTickerStream(Ticker ticker);
  Future<Stream<TickerStats>> getTickerStatsStream(Ticker ticker);
}

class MarketDataSourceImpl implements MarketDataSource {
  final DataSourceUtils dataSourceUtils;
  WebSocket? _bookTickerWebSocket;
  StreamController<BookTicker>? _bookTickerStreamController;
  WebSocket? _tickerStatsWebSocket;
  StreamController<TickerStats>? _tickerStatsStreamController;

  MarketDataSourceImpl(this.dataSourceUtils);

  @override
  Future<Stream<BookTicker>> getBookTickerStream(Ticker ticker) async {
    const pathWS = '/ws/';

    final symbol = TickerModel.fromTicker(ticker).symbol;

    _bookTickerWebSocket?.close();
    _bookTickerStreamController?.close();
    _bookTickerStreamController = StreamController<BookTicker>();

    try {
      _bookTickerWebSocket = await dataSourceUtils.webSocketConnect(binanceWebSocketUrl + pathWS + '$symbol@bookTicker');

      if (_bookTickerWebSocket!.readyState == WebSocket.open) {
        _bookTickerWebSocket!.listen(
          (data) {
            final jsonData = jsonDecode(data);
            final bookTickerModel = BookTickerModel.fromJson(jsonData, ticker);
            _bookTickerStreamController!.add(bookTickerModel);
          },
          onDone: () => print('[+] BookTicker stream done.'),
          onError: (err) {
            print('[!] Error: ${err.toString()}');
            _bookTickerStreamController!.addError(Error());
          },
          cancelOnError: true,
        );
      } else {
        print('[!] Connection denied.');
      }
    } catch (err) {
      _bookTickerWebSocket?.close();
      _bookTickerStreamController!.close();
      throw ServerException(message: "Could not obtain BookTicker stream.");
    }

    return _bookTickerStreamController!.stream;
  }

  @override
  Future<Stream<TickerStats>> getTickerStatsStream(Ticker ticker) async {
    const pathWS = '/ws/';

    final symbol = TickerModel.fromTicker(ticker).symbol;

    _tickerStatsWebSocket?.close();
    _tickerStatsStreamController?.close();
    _tickerStatsStreamController = StreamController<TickerStats>();

    try {
      _tickerStatsWebSocket = await dataSourceUtils.webSocketConnect(binanceWebSocketUrl + pathWS + '$symbol@ticker');

      if (_tickerStatsWebSocket!.readyState == WebSocket.open) {
        _tickerStatsWebSocket!.listen(
          (data) {
            final jsonData = jsonDecode(data);
            final tickerStatsModel = TickerStatsModel.fromJson(jsonData, ticker);
            _tickerStatsStreamController!.add(tickerStatsModel);
          },
          onDone: () => print('[+] TickerStats stream done.'),
          onError: (err) {
            print('[!] Error: ${err.toString()}');
            _tickerStatsStreamController!.addError(Error());
          },
          cancelOnError: true,
        );
      } else {
        print('[!] Connection denied.');
      }
    } catch (err) {
      _tickerStatsWebSocket?.close();
      _tickerStatsStreamController!.close();
      throw ServerException(message: "Could not obtain TickerStats stream.");
    }

    return _tickerStatsStreamController!.stream;
  }
}
