import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/domain/entities/bookticker.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/market_respository.dart';
import 'package:price_action_orders/domain/usecases/market_get_bookticker_stream_uc.dart';
import 'market_get_bookticker_stream_uc_test.mocks.dart';

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

@GenerateMocks([MarketRepository])
void main() {
  late GetBookTickerStream usecase;
  late MockMarketRepository mockMarketRepository;

  setUp(() {
    mockMarketRepository = MockMarketRepository();
    usecase = GetBookTickerStream(mockMarketRepository);
  });

  final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
  final Params tParams = Params(tTicker);
  final Stream<BookTicker> tBookTickerStream = Stream<BookTicker>.fromIterable(_bookTickers);

  test(
    'should return bookticker stream when the call to the repository is successful',
    () async {
      //arrange
      when(mockMarketRepository.getBookTickerStream(tTicker)).thenAnswer((_) async => Right(tBookTickerStream));
      //act
      final Either<Failure, Stream<BookTicker>>? result = await usecase(tParams);
      //assert
      verify(mockMarketRepository.getBookTickerStream(tTicker));
      verifyNoMoreInteractions(mockMarketRepository);
      expect(result, Right(tBookTickerStream));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockMarketRepository.getBookTickerStream(tTicker)).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final Either<Failure, Stream<BookTicker>>? result = await usecase(tParams);
      //assert
      verify(mockMarketRepository.getBookTickerStream(tTicker));
      verifyNoMoreInteractions(mockMarketRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
