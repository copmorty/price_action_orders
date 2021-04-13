import 'package:price_action_orders/data/models/bookticker_model.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:meta/meta.dart';

final String socketBase = 'wss://stream.binance.com:9443/ws/';
final String socketBaseTest = 'wss://testnet.binance.vision/ws/';

abstract class BookTickerDataSource {
  /// Websocket stream
  Stream<BookTicker> streamBookTicker({@required baseAsset, @required quoteAsset});
}

class BookTickerDataSourceImpl implements BookTickerDataSource {
  IOWebSocketChannel channel;

  @override
  Stream<BookTicker> streamBookTicker({@required baseAsset, @required quoteAsset}) {
    final String symbol = baseAsset + quoteAsset;
    String pair = symbol.toLowerCase().replaceAll(RegExp(r'/'), '');
    String socket = socketBase + '$pair@bookTicker';
    channel?.sink?.close();
    channel = IOWebSocketChannel.connect(socket);

    return channel.stream.map((snap) {
      return BookTickerModel.fromStringifiedMap(strMap: snap, baseAsset: baseAsset, quoteAsset: quoteAsset);
    });
  }
}
