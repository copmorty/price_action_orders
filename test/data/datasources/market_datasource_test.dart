import 'dart:async';
import 'dart:io' show WebSocket;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/utils/datasource_utils.dart';
import 'package:price_action_orders/data/datasources/market_datasource.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
import 'market_datasource_test.mocks.dart';

class FakeWebSocket extends Fake implements WebSocket {
  StreamSubscription<dynamic> _streamSubscription = Stream<dynamic>.empty().listen((event) {});

  @override
  int get readyState => WebSocket.open;
  @override
  Future<void> close([int? code, String? reason]) => _streamSubscription.cancel();
  @override
  StreamSubscription<dynamic> listen(void onData(dynamic event)?, {Function? onError, void onDone()?, bool? cancelOnError}) => _streamSubscription;
}

@GenerateMocks([DataSourceUtils])
void main() {
  late MarketDataSourceImpl dataSource;
  late MockDataSourceUtils mockDataSourceUtils;

  setUp(() {
    mockDataSourceUtils = MockDataSourceUtils();
    dataSource = MarketDataSourceImpl(mockDataSourceUtils);
  });

  group('getBookTickerStream', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final FakeWebSocket tWebSocket = FakeWebSocket();
    tWebSocket.close();

    test(
      'should establish a websocket connection and return a bookticker stream when the communication is successful',
      () async {
        //arrange
        when(mockDataSourceUtils.webSocketConnect(any)).thenAnswer((_) async => tWebSocket);
        //act
        final result = await dataSource.getBookTickerStream(tTicker);
        //assert
        verify(mockDataSourceUtils.webSocketConnect(any));
        verifyNoMoreInteractions(mockDataSourceUtils);
        expect(result, isA<Stream<BookTicker>>());
      },
    );

    test(
      'should throw a server exception when the communication is unsuccessful',
      () async {
        //arrange
        when(mockDataSourceUtils.webSocketConnect(any)).thenThrow(Error());
        //assert
        expect(() => dataSource.getBookTickerStream(tTicker), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });

  group('getTickerStatsStream', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final FakeWebSocket tWebSocket = FakeWebSocket();
    tWebSocket.close();

    test(
      'should establish a websocket connection and return a ticker stats stream when the communication is successful',
      () async {
        //arrange
        when(mockDataSourceUtils.webSocketConnect(any)).thenAnswer((_) async => tWebSocket);
        //act
        final result = await dataSource.getTickerStatsStream(tTicker);
        //assert
        verify(mockDataSourceUtils.webSocketConnect(any));
        verifyNoMoreInteractions(mockDataSourceUtils);
        expect(result, isA<Stream<TickerStats>>());
      },
    );

    test(
      'should throw a server exception when the communication is unsuccessful',
      () async {
        //arrange
        when(mockDataSourceUtils.webSocketConnect(any)).thenThrow(Error());
        //assert
        expect(() => dataSource.getTickerStatsStream(tTicker), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
