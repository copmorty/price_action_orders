import 'dart:async';
import 'dart:io' show WebSocket;
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/data/models/bookticker_model.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
// import 'package:web_socket_channel/io.dart';

abstract class BookTickerDataSource {
  /// Websocket stream
  Future<Stream<BookTicker>> streamBookTicker({@required baseAsset, @required quoteAsset});
}

class BookTickerDataSourceImpl implements BookTickerDataSource {
  WebSocket _webSocket;
  StreamController<BookTicker> _streamController;

  @override
  Future<Stream<BookTicker>> streamBookTicker({baseAsset, quoteAsset}) async {
    const pathWS = '/ws/';
    final String symbol = baseAsset + quoteAsset;
    String pair = symbol.toLowerCase().replaceAll(RegExp(r'/'), '');

    _webSocket?.close();
    _streamController?.close();
    _streamController = StreamController<BookTicker>();
    
    try {
      _webSocket = await WebSocket.connect(binanceWebSocketUrl + pathWS + '$pair@bookTicker');
      if (_webSocket.readyState == WebSocket.open) {
        _webSocket.listen(
          (data) {
            final bookTickerModel = BookTickerModel.fromStringifiedMap(strMap: data, baseAsset: baseAsset, quoteAsset: quoteAsset);
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

    // WebSocket.connect(binanceWebSocketUrl + pathWS + '$pair@bookTicker').then(
    //   (WebSocket ws) {
    //     if (ws?.readyState == WebSocket.open) {
    //       ws.listen(
    //         (data) {
    //           print(data);
    //           final bookTickerModel = BookTickerModel.fromStringifiedMap(strMap: data, baseAsset: baseAsset, quoteAsset: quoteAsset);
    //           _streamController.add(bookTickerModel);
    //         },
    //         onDone: () => print('[+]Done :)'),
    //         onError: (err) => print('[!]Error -- ${err.toString()}'),
    //         cancelOnError: true,
    //       );
    //     } else {
    //       print('[!]Connection Denied');
    //     }
    //   },
    // ).catchError(
    //   (err) {
    //     print(err);
    //     _streamController.close();
    //     throw ServerException();
    //   },
    // );

    return _streamController.stream;
  }
}


// abstract class BookTickerDataSource {
//   /// Websocket stream
//   Stream<BookTicker> streamBookTicker({@required baseAsset, @required quoteAsset});
// }

// class BookTickerDataSourceImpl implements BookTickerDataSource {
//   IOWebSocketChannel channel;

//   @override
//   Stream<BookTicker> streamBookTicker({@required baseAsset, @required quoteAsset}) {
//     const path = '/ws/';
//     final String symbol = baseAsset + quoteAsset;
//     String pair = symbol.toLowerCase().replaceAll(RegExp(r'/'), '');
//     String socket = binanceWebSocketUrl + path + '$pair@bookTicker';
//     channel?.sink?.close();
//     channel = IOWebSocketChannel.connect(socket);

//     return channel.stream.map((snap) {
//       return BookTickerModel.fromStringifiedMap(strMap: snap, baseAsset: baseAsset, quoteAsset: quoteAsset);
//     });
//   }
// }
