import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/data/models/exchange_info_model.dart';
import 'package:price_action_orders/data/models/exchange_symbol_info_model.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/usecases/user_get_last_ticker_uc.dart';
import 'package:price_action_orders/domain/usecases/user_set_last_ticker_uc.dart';
import 'package:price_action_orders/presentation/logic/exchangeinfo_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/ticker_state_notifier.dart';
import 'ticker_state_notifier_test.mocks.dart';

final _exchangeSymbolInfo = ExchangeSymbolInfoModel(
  symbol: 'ETHBTC',
  status: 'TRADING',
  baseAsset: 'ETH',
  baseAssetPrecision: 8,
  quoteAsset: 'BTC',
  quotePrecision: 8,
  quoteAssetPrecision: 8,
  baseCommissionPrecision: 8,
  quoteCommissionPrecision: 8,
  orderTypes: [
    BinanceOrderType.LIMIT,
    BinanceOrderType.LIMIT_MAKER,
    BinanceOrderType.MARKET,
    BinanceOrderType.STOP_LOSS_LIMIT,
    BinanceOrderType.TAKE_PROFIT_LIMIT,
  ],
  icebergAllowed: true,
  ocoAllowed: true,
  quoteOrderQtyMarketAllowed: true,
  isSpotTradingAllowed: true,
  isMarginTradingAllowed: true,
  filters: [
    {"filterType": "PRICE_FILTER", "minPrice": "0.00000100", "maxPrice": "922327.00000000", "tickSize": "0.00000100"},
    {"filterType": "PERCENT_PRICE", "multiplierUp": "5", "multiplierDown": "0.2", "avgPriceMins": 5},
    {"filterType": "LOT_SIZE", "minQty": "0.00100000", "maxQty": "100000.00000000", "stepSize": "0.00100000"},
    {"filterType": "MIN_NOTIONAL", "minNotional": "0.00010000", "applyToMarket": true, "avgPriceMins": 5},
    {"filterType": "ICEBERG_PARTS", "limit": 10},
    {"filterType": "MARKET_LOT_SIZE", "minQty": "0.00000000", "maxQty": "1041.49940653", "stepSize": "0.00000000"},
    {"filterType": "MAX_NUM_ORDERS", "maxNumOrders": 200},
    {"filterType": "MAX_NUM_ALGO_ORDERS", "maxNumAlgoOrders": 5},
  ],
  permissions: ['SPOT', 'MARGIN'],
);

@GenerateMocks([GetLastTicker, SetLastTicker, ExchangeInfoNotifier])
void main() {
  late TickerNotifier notifier;
  late MockGetLastTicker mockGetLastTicker;
  late MockSetLastTicker mockSetLastTicker;
  late MockExchangeInfoNotifier mockExchangeInfoNotifier;

  setUp(() {
    mockGetLastTicker = MockGetLastTicker();
    mockSetLastTicker = MockSetLastTicker();
    mockExchangeInfoNotifier = MockExchangeInfoNotifier();
    notifier = TickerNotifier(getLastTicker: mockGetLastTicker, setLastTicker: mockSetLastTicker, exchangeInfoNotifier: mockExchangeInfoNotifier, init: false);
  });

  final tExchangeInfo = ExchangeInfoModel(
    timezone: 'UTC',
    serverTime: 1628692692594,
    rateLimits: [
      {"rateLimitType": "REQUEST_WEIGHT", "interval": "MINUTE", "intervalNum": 1, "limit": 1200},
      {"rateLimitType": "ORDERS", "interval": "SECOND", "intervalNum": 10, "limit": 50},
      {"rateLimitType": "ORDERS", "interval": "DAY", "intervalNum": 1, "limit": 160000},
      {"rateLimitType": "RAW_REQUESTS", "interval": "MINUTE", "intervalNum": 5, "limit": 6100},
    ],
    exchangeFilters: [],
    symbols: [_exchangeSymbolInfo],
  );
  final tTicker1 = Ticker(baseAsset: 'ETH', quoteAsset: 'BTC');
  final tTicker2 = Ticker(baseAsset: 'AAVE', quoteAsset: 'USDT');

  group('initialization', () {
    test(
      'should state TickerInitial, TickerLoading and TickerLoaded when there is a ticker cached',
      () async {
        //arrange
        final List<TickerState> tStates = [
          TickerInitial(),
          TickerLoading(),
          TickerLoaded(tTicker1),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetLastTicker.call(NoParams())).thenAnswer((_) async => Right(tTicker1));
        when(mockExchangeInfoNotifier.getExchangeInfo()).thenAnswer((_) async => Right(tExchangeInfo));
        //act
        await notifier.initialization();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetLastTicker.call(NoParams()));
        verifyNoMoreInteractions(mockGetLastTicker);
        verifyZeroInteractions(mockSetLastTicker);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state TickerInitial, TickerLoading and TickerInitial when the ticker cached is no longer available',
      () async {
        //arrange
        final List<TickerState> tStates = [
          TickerInitial(),
          TickerLoading(),
          TickerInitial(),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetLastTicker.call(NoParams())).thenAnswer((_) async => Right(tTicker2));
        when(mockExchangeInfoNotifier.getExchangeInfo()).thenAnswer((_) async => Right(tExchangeInfo));
        //act
        await notifier.initialization();
        await Future.delayed(const Duration(milliseconds: 100), () {});
        //assert
        verify(mockGetLastTicker.call(NoParams()));
        verifyNoMoreInteractions(mockGetLastTicker);
        verifyZeroInteractions(mockSetLastTicker);
        expect(actualStates, tStates);
      },
    );

    test(
      'should state TickerInitial when there is no ticker cached',
      () async {
        //arrange
        final List<TickerState> tStates = [
          TickerInitial(),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockGetLastTicker.call(NoParams())).thenAnswer((_) async => Left(CacheFailure()));
        //act
        await notifier.initialization();
        //assert
        verify(mockGetLastTicker.call(NoParams()));
        verifyNoMoreInteractions(mockGetLastTicker);
        verifyZeroInteractions(mockSetLastTicker);
        expect(actualStates, tStates);
      },
    );
  });

  group('setTicker', () {
    test(
      'should return true when the communication to the server is successful and the ticker is found',
      () async {
        //arrange
        when(mockExchangeInfoNotifier.getExchangeInfo()).thenAnswer((_) async => Right(tExchangeInfo));
        when(mockSetLastTicker.call(Params(tTicker1))).thenAnswer((_) async => Right(null));
        //act
        final result = await notifier.setTicker(tTicker1);
        //assert
        verify(mockExchangeInfoNotifier.getExchangeInfo());
        verify(mockSetLastTicker.call(Params(tTicker1)));
        verifyNoMoreInteractions(mockExchangeInfoNotifier);
        verifyNoMoreInteractions(mockSetLastTicker);
        expect(result, true);
      },
    );

    test(
      'should return false when the communication to the server is successful, but the ticker is not found',
      () async {
        //arrange
        when(mockExchangeInfoNotifier.getExchangeInfo()).thenAnswer((_) async => Right(tExchangeInfo));
        //act
        final result = await notifier.setTicker(tTicker2);
        //assert
        verify(mockExchangeInfoNotifier.getExchangeInfo());
        verifyNoMoreInteractions(mockExchangeInfoNotifier);
        verifyZeroInteractions(mockSetLastTicker);
        expect(result, false);
      },
    );

    test(
      'should return false when the communication to the server is unsuccessful',
      () async {
        //arrange
        when(mockExchangeInfoNotifier.getExchangeInfo()).thenAnswer((_) async => Left(ServerFailure()));
        //act
        final result = await notifier.setTicker(tTicker1);
        //assert
        verify(mockExchangeInfoNotifier.getExchangeInfo());
        verifyNoMoreInteractions(mockExchangeInfoNotifier);
        verifyZeroInteractions(mockSetLastTicker);
        expect(result, false);
      },
    );

    test(
      'should state TickerInitial, TickerLoading and TickerLoaded when the communication to the server is successful and the ticker is found',
      () async {
        //arrange
        final List<TickerState> tStates = [
          TickerInitial(),
          TickerLoading(),
          TickerLoaded(tTicker1),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockExchangeInfoNotifier.getExchangeInfo()).thenAnswer((_) async => Right(tExchangeInfo));
        when(mockSetLastTicker.call(Params(tTicker1))).thenAnswer((_) async => Right(null));
        //act
        await notifier.setTicker(tTicker1);
        //assert
        verify(mockExchangeInfoNotifier.getExchangeInfo());
        verifyNoMoreInteractions(mockExchangeInfoNotifier);
        expect(tStates, actualStates);
      },
    );

    test(
      'should state TickerInitial, TickerLoading and TickerInitial when the communication to the server is successful, but the ticker is not found',
      () async {
        final List<TickerState> tStates = [
          TickerInitial(),
          TickerLoading(),
          TickerInitial(),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockExchangeInfoNotifier.getExchangeInfo()).thenAnswer((_) async => Right(tExchangeInfo));
        //act
        await notifier.setTicker(tTicker2);
        //assert
        verify(mockExchangeInfoNotifier.getExchangeInfo());
        verifyNoMoreInteractions(mockExchangeInfoNotifier);
        verifyZeroInteractions(mockSetLastTicker);
        expect(tStates, actualStates);
      },
    );

    test(
      'should state TickerInitial, TickerLoading and TickerInitial when the communication to the server is unsuccessful',
      () async {
        final List<TickerState> tStates = [
          TickerInitial(),
          TickerLoading(),
          TickerInitial(),
        ];
        final List<TickerState> actualStates = [];
        notifier.addListener((state) => actualStates.add(state));
        when(mockExchangeInfoNotifier.getExchangeInfo()).thenAnswer((_) async => Left(ServerFailure()));
        //act
        await notifier.setTicker(tTicker2);
        //assert
        verify(mockExchangeInfoNotifier.getExchangeInfo());
        verifyNoMoreInteractions(mockExchangeInfoNotifier);
        verifyZeroInteractions(mockSetLastTicker);
        expect(tStates, actualStates);
      },
    );

    test(
      'should make a call to set the last ticker',
      () async {
        //arrange
        when(mockExchangeInfoNotifier.getExchangeInfo()).thenAnswer((_) async => Right(tExchangeInfo));
        when(mockSetLastTicker.call(Params(tTicker1))).thenAnswer((_) async => Right(null));
        //act
        await notifier.setTicker(tTicker1);
        //assert
        verify(mockExchangeInfoNotifier.getExchangeInfo());
        verify(mockSetLastTicker.call(Params(tTicker1)));
        verifyNoMoreInteractions(mockExchangeInfoNotifier);
        verifyNoMoreInteractions(mockSetLastTicker);
      },
    );
  });
}
