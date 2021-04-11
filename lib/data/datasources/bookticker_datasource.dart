import 'package:price_action_orders/data/models/bookticker_model.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:web_socket_channel/io.dart';

String pair = 'BTC/USDT';
String parameterPair = pair.toLowerCase().replaceAll(RegExp(r'/'), '');
String socket = 'wss://stream.binance.com:9443/ws/$parameterPair@bookTicker';

abstract class BookTickerDataSource {
  /// Websocket stream
  Stream<BookTicker> getBookTicker();
}

class BookTickerDataSourceImpl implements BookTickerDataSource {
  final channel = IOWebSocketChannel.connect(socket);

  @override
  Stream<BookTicker> getBookTicker() {
    return channel.stream.map((snap) {
      return BookTickerModel.fromStringifiedMap(snap);
    });
  }
}
