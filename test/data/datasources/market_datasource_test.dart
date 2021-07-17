import 'dart:async';
import 'dart:io' show WebSocket;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/constants.dart';
import 'package:price_action_orders/core/utils/datasource_utils.dart';
import 'package:price_action_orders/data/datasources/market_datasource.dart';
import 'package:price_action_orders/data/models/ticker_model.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../attachments/attachment_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockDataSourceUtils extends Mock implements DataSourceUtils {}

class FakeWebSocket extends Fake implements WebSocket {
  StreamSubscription<BookTicker> _streamSubscription;

  @override
  int get readyState => WebSocket.open;
  @override
  Future close([int code, String reason]) => _streamSubscription?.cancel();
  @override
  StreamSubscription<BookTicker> listen(void onData(BookTicker event), {Function onError, void onDone(), bool cancelOnError}) => _streamSubscription;
}

void main() {
  MarketDataSourceImpl /*!*/ dataSource;
  MockSharedPreferences /*!*/ mockSharedPreferences;
  MockDataSourceUtils /*!*/ mockDataSourceUtils;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockDataSourceUtils = MockDataSourceUtils();
    dataSource = MarketDataSourceImpl(sharedPreferences: mockSharedPreferences, dataSourceUtils: mockDataSourceUtils);
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

  group('cacheLastTicker', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');

    test(
      'should call shared preferences to save the ticker',
      () async {
        //arrange
        when(mockSharedPreferences.setString(LAST_TICKER, any)).thenAnswer((_) async => null);
        //act
        await dataSource.cacheLastTicker(tTicker);
        //assert
        verify((mockSharedPreferences.setString(LAST_TICKER, any)));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });

  group('getLastTicker', () {
    final Ticker tTicker = TickerModel(baseAsset: 'BNB', quoteAsset: 'USDT');

    test(
      'should retrieve a previously cached ticker',
      () async {
        //arrange
        final String jsonString = attachment('ticker.json');
        when(mockSharedPreferences.getString(LAST_TICKER)).thenReturn(jsonString);
        //act
        final result = await dataSource.getLastTicker();
        //assert
        verify(mockSharedPreferences.getString(LAST_TICKER));
        verifyNoMoreInteractions(mockSharedPreferences);
        expect(result, tTicker);
      },
    );

    test(
      'should throw a cache exception when there is no ticker saved',
      () async {
        //arrange
        when(mockSharedPreferences.getString(LAST_TICKER)).thenReturn(null);
        //act
        final call = dataSource.getLastTicker;
        //assert
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
      },
    );
  });
}
