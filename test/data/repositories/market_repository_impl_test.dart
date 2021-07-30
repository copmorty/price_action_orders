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
import 'package:price_action_orders/domain/entities/ticker_stats.dart';
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
      'should return BookTicker stream when the call to data source is successful',
      () async {
        //arrange
        when(mockMarketDataSource.getBookTickerStream(tTicker)).thenAnswer((_) async => tBookTickerStream);
        //act
        final result = await repository.getBookTickerStream(tTicker);
        //assert
        verify(mockMarketDataSource.getBookTickerStream(tTicker));
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
    final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
    final Stream<TickerStats> tTickerStatsStream = Stream<TickerStats>.empty();

    test(
      'should return TickerStats stream when the call to data source is successful',
      () async {
        //arrange
        when(mockMarketDataSource.getTickerStatsStream(tTicker)).thenAnswer((_) async => tTickerStatsStream);
        //act
        final result = await repository.getTickerStatsStream(tTicker);
        //assert
        verify(mockMarketDataSource.getTickerStatsStream(tTicker));
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Right(tTickerStatsStream));
      },
    );

    test(
      'should return server failure when the call to data source is unsuccessful',
      () async {
        //arrange
        when(mockMarketDataSource.getTickerStatsStream(tTicker)).thenThrow(ServerException(message: "Could not obtain TickerStats stream."));
        //act
        final result = await repository.getTickerStatsStream(tTicker);
        //assert
        verify(mockMarketDataSource.getTickerStatsStream(tTicker));
        verifyNoMoreInteractions(mockMarketDataSource);
        expect(result, Left(ServerFailure(message: "Could not obtain TickerStats stream.")));
      },
    );
  });
}
