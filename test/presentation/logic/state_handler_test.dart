import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/presentation/logic/accountinfo_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/bookticker_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/orders_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/state_handler.dart';
import 'package:price_action_orders/presentation/logic/ticker_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/tickerstats_state_notifier.dart';
import 'package:price_action_orders/presentation/logic/userdata_stream.dart';
import 'state_handler_test.mocks.dart';

@GenerateMocks([UserDataStream, AccountInfoNotifier, OrdersNotifier, BookTickerNotifier, TickerNotifier, TickerStatsNotifier])
void main() {
  late StateHandler stateHandler;
  late MockUserDataStream mockUserDataStream;
  late MockAccountInfoNotifier mockAccountInfoNotifier;
  late MockOrdersNotifier mockOrdersNotifier;
  late MockBookTickerNotifier mockBookTickerNotifier;
  late MockTickerNotifier mockTickerNotifier;
  late MockTickerStatsNotifier mockTickerStatsNotifier;

  setUp(() {
    mockUserDataStream = MockUserDataStream();
    mockAccountInfoNotifier = MockAccountInfoNotifier();
    mockOrdersNotifier = MockOrdersNotifier();
    mockBookTickerNotifier = MockBookTickerNotifier();
    mockTickerNotifier = MockTickerNotifier();
    mockTickerStatsNotifier = MockTickerStatsNotifier();
    stateHandler = StateHandler(
      userDataStream: mockUserDataStream,
      accountInfoNotifier: mockAccountInfoNotifier,
      ordersNotifier: mockOrdersNotifier,
      bookTickerNotifier: mockBookTickerNotifier,
      tickerNotifier: mockTickerNotifier,
      tickerStatsNotifier: mockTickerStatsNotifier,
    );
  });

  void _verifyReloadUserStreams() {
    verify(mockUserDataStream.initialization());
    verify(mockAccountInfoNotifier.getAccountInfo());
    verify(mockOrdersNotifier.getOpenOrders());
    verifyNoMoreInteractions(mockUserDataStream);
    verifyNoMoreInteractions(mockAccountInfoNotifier);
    verifyNoMoreInteractions(mockOrdersNotifier);
  }

  group('dispatchTicker', () {
    final tTicker = Ticker(baseAsset: 'BNB', quoteAsset: 'USDT');

    test(
      'should call streamBookTicker and streamTickerStats, when there is exchangeInfo and the ticker is found',
      () async {
        //arrange
        when(mockTickerNotifier.setTicker(tTicker)).thenAnswer((_) async => true);
        //act
        await stateHandler.dispatchTicker(tTicker);
        //assert
        verify(mockTickerNotifier.setTicker(tTicker));
        verify(mockBookTickerNotifier.streamBookTicker(tTicker));
        verify(mockTickerStatsNotifier.streamTickerStats(tTicker));
        verifyNoMoreInteractions(mockTickerNotifier);
        verifyNoMoreInteractions(mockBookTickerNotifier);
        verifyNoMoreInteractions(mockTickerStatsNotifier);
      },
    );

    test(
      'should not call streamBookTicker and streamTickerStats, when there is no exchangeInfo or the ticker is not found',
      () async {
        //arrange
        when(mockTickerNotifier.setTicker(tTicker)).thenAnswer((_) async => false);
        //act
        await stateHandler.dispatchTicker(tTicker);
        //assert
        verify(mockTickerNotifier.setTicker(tTicker));
        verifyNoMoreInteractions(mockTickerNotifier);
        verifyZeroInteractions(mockBookTickerNotifier);
        verifyZeroInteractions(mockTickerStatsNotifier);
      },
    );
  });

  group('reloadAccountInfo', () {
    test(
      'should call initialization, getAccountInfo, and getOpenOrders',
      () async {
        //act
        stateHandler.reloadAccountInfo();
        //assert
        _verifyReloadUserStreams();
      },
    );
  });

  group('reloadOrderLists', () {
    test(
      'should call initialization, getAccountInfo, and getOpenOrders',
      () async {
        //act
        stateHandler.reloadOrderLists();
        //assert
        _verifyReloadUserStreams();
      },
    );
  });
}
