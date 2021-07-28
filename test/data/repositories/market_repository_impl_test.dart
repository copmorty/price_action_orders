import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/data/datasources/market_datasource.dart';
import 'package:price_action_orders/data/repositories/market_repository_impl.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'market_repository_impl_test.mocks.dart';

final _bookTickers = [
  BookTicker(
    updatedId: 1624022520704,
    symbol: 'BNBUSDT',
    ticker: Ticker(baseAsset: 'BNB', quoteAsset: 'USDT'),
    bidPrice: Decimal.parse('353'),
    bidQty: Decimal.parse('1.5'),
    askPrice: Decimal.parse('354'),
    askQty: Decimal.parse('2'),
  ),
  BookTicker(
    updatedId: 1624022520704,
    symbol: 'BNBUSDT',
    ticker: Ticker(baseAsset: 'BNB', quoteAsset: 'USDT'),
    bidPrice: Decimal.parse('353.5'),
    bidQty: Decimal.parse('1.1'),
    askPrice: Decimal.parse('354.2'),
    askQty: Decimal.parse('1.5'),
  ),
];

@GenerateMocks([MarketDataSource])
void main() {
  late MarketRepositoryImpl repository;
  late MockMarketDataSource mockMarketDataSource;

  setUp(() {
    mockMarketDataSource = MockMarketDataSource();
    repository = MarketRepositoryImpl(mockMarketDataSource);
  });

  group('getBookTickerStream', () {
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final Stream<BookTicker> tBookTickerStream = Stream<BookTicker>.fromIterable(_bookTickers);

    test(
      'should return BookTicker stream and cache the ticker when the call to data source is successful',
      () async {
        //arrange
        when(mockMarketDataSource.getBookTickerStream(tTicker)).thenAnswer((_) async => tBookTickerStream);
        //act
        final result = await repository.getBookTickerStream(tTicker);
        //assert
        verify(mockMarketDataSource.getBookTickerStream(tTicker));
        verify(mockMarketDataSource.cacheLastTicker(tTicker));
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Right(tBookTickerStream));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful',
      () async {
        //arrange
        when(mockMarketDataSource.getBookTickerStream(tTicker)).thenThrow(ServerException(message: "Could not obtain BookTicker stream."));
        //act
        final result = await repository.getBookTickerStream(tTicker);
        //assert
        verify(mockMarketDataSource.getBookTickerStream(tTicker));
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Left(ServerFailure(message: "Could not obtain BookTicker stream.")));
      },
    );
  });

group('getTickerStatsStream', () {
   test(
     'should ',
     () async {
       //arrange
       
       //act
       
       //assert
       expect(actual, matcher)
     },
   );
});

  group('getLastTicker', () {
    final Ticker tTicker = Ticker(baseAsset: 'BTC', quoteAsset: 'USDT');

    test(
      'should return a ticker when the call to data source is successful',
      () async {
        //arrange
        when(mockMarketDataSource.getLastTicker()).thenAnswer((_) async => tTicker);
        //act
        final result = await repository.getLastTicker();
        //assert
        verify(mockMarketDataSource.getLastTicker());
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Right(tTicker));
      },
    );

    test(
      'should return cache failure when the call to data source is unsuccessful',
      () async {
        //arrange
        when(mockMarketDataSource.getLastTicker()).thenThrow(CacheException());
        //act
        final result = await repository.getLastTicker();
        //assert
        verify(mockMarketDataSource.getLastTicker());
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Left(CacheFailure()));
      },
    );
  });
}
