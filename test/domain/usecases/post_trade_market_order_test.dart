import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_fill.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/repositories/trade_repository.dart';
import 'package:price_action_orders/domain/usecases/post_trade_market_order.dart';
import 'post_trade_market_order_test.mocks.dart';

@GenerateMocks([TradeRepository])
void main() {
  late PostMarketOrder usecase;
  late MockTradeRepository mockTradeRepository;

  setUp(() {
    mockTradeRepository = MockTradeRepository();
    usecase = PostMarketOrder(mockTradeRepository);
  });

  final Ticker tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');
  final MarketOrderRequest tMarketOrder = MarketOrderRequest(
    ticker: tTicker,
    side: BinanceOrderSide.BUY,
    quoteOrderQty: Decimal.parse('20'),
  );
  final tOrderResponseFull = OrderResponseFull(
    ticker: tTicker,
    symbol: 'BNBUSDT',
    orderId: 3065299,
    orderListId: -1,
    clientOrderId: 'T2Np7YlcUojhYefWoqqBga',
    transactTime: 1624117720140,
    price: Decimal.parse('0.00000000'),
    origQty: Decimal.parse('0.05000000'),
    executedQty: Decimal.parse('0.05000000'),
    cummulativeQuoteQty: Decimal.parse('16.96450000'),
    status: BinanceOrderStatus.FILLED,
    timeInForce: BinanceOrderTimeInForce.GTC,
    type: BinanceOrderType.MARKET,
    side: BinanceOrderSide.BUY,
    fills: [
      OrderFill(
        price: Decimal.parse('339.29000000'),
        quantity: Decimal.parse('0.05000000'),
        commission: Decimal.parse('0.00000000'),
        commissionAsset: 'BNB',
        tradeId: 392000,
      ),
    ],
  );

  test(
    'should return a full order response when the call to the repository is successful',
    () async {
      //arrange
      when(mockTradeRepository.postMarketOrder(tMarketOrder)).thenAnswer((_) async => Right(tOrderResponseFull));
      //act
      final Either<Failure, OrderResponseFull>? result = await usecase(Params(tMarketOrder));
      //assert
      verify(mockTradeRepository.postMarketOrder(tMarketOrder));
      verifyNoMoreInteractions(mockTradeRepository);
      expect(result, Right(tOrderResponseFull));
    },
  );

  test(
    'should return a failure when the call to the repository is unsuccessful',
    () async {
      //arrange
      when(mockTradeRepository.postMarketOrder(tMarketOrder)).thenAnswer((_) async => Left(ServerFailure()));
      //act
      final Either<Failure, OrderResponseFull>? result = await usecase(Params(tMarketOrder));
      //assert
      verify(mockTradeRepository.postMarketOrder(tMarketOrder));
      verifyNoMoreInteractions(mockTradeRepository);
      expect(result, Left(ServerFailure()));
    },
  );
}
