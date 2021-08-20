import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:price_action_orders/domain/usecases/market_get_exchangeinfo_uc.dart';
import 'package:price_action_orders/domain/usecases/user_check_account_status_uc.dart';
import 'package:price_action_orders/presentation/logic/auth_handler.dart';
import 'package:price_action_orders/presentation/logic/exchangeinfo_state_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/utils/datasource_utils.dart';
import 'data/datasources/market_datasource.dart';
import 'data/datasources/trade_datasource.dart';
import 'data/datasources/user_datasource.dart';
import 'data/repositories/market_repository_impl.dart';
import 'data/repositories/trade_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/market_respository.dart';
import 'domain/repositories/trade_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/market_get_bookticker_stream_uc.dart';
import 'domain/usecases/user_get_last_ticker_uc.dart';
import 'domain/usecases/market_get_tickerstats_stream_uc.dart';
import 'domain/usecases/user_get_accountinfo_uc.dart';
import 'domain/usecases/user_get_userdata_stream_uc.dart';
import 'domain/usecases/user_get_open_orders_uc.dart';
import 'domain/usecases/trade_cancel_order_uc.dart';
import 'domain/usecases/trade_post_order_uc.dart';
import 'domain/usecases/user_set_last_ticker_uc.dart';
import 'presentation/logic/accountinfo_state_notifier.dart';
import 'presentation/logic/bookticker_state_notifier.dart';
import 'presentation/logic/ticker_state_notifier.dart';
import 'presentation/logic/orders_state_notifier.dart';
import 'presentation/logic/trade_state_notifier.dart';
import 'presentation/logic/userdata_stream.dart';
import 'presentation/logic/state_handler.dart';
import 'presentation/logic/tickerstats_state_notifier.dart';

late SharedPreferences sharedPreferencesInstance;

Future<void> init() async {
  sharedPreferencesInstance = await SharedPreferences.getInstance();
}

// Logic
final bookTickerNotifierProvider = StateNotifierProvider<BookTickerNotifier, BookTickerState>(
  (ref) => BookTickerNotifier(
    getLastTicker: ref.watch(getLastTicker),
    getBookTickerStream: ref.watch(getBookTickerStream),
  ),
);
final tradeNotifierProvider = StateNotifierProvider<TradeNotifier, TradeState>(
  (ref) => TradeNotifier(
    postOrder: ref.watch(postOrder),
    postCancelOrder: ref.watch(postCancelOrder),
  ),
);
final tickerNotifierProvider = StateNotifierProvider<TickerNotifier, TickerState>(
  (ref) => TickerNotifier(
    getLastTicker: ref.watch(getLastTicker),
    setLastTicker: ref.watch(setLastTicker),
    exchangeInfoNotifier: ref.watch(exchangeInfoNotifierProvider.notifier),
  ),
);
final accountInfoNotifierProvider = StateNotifierProvider<AccountInfoNotifier, AccountInfoState>(
  (ref) => AccountInfoNotifier(
    getAccountInfo: ref.watch(getAccountInfo),
    userDataStream: ref.watch(userDataStreamProvider),
  ),
);
final ordersNotifierProvider = StateNotifierProvider<OrdersNotifier, OrdersState>(
  (ref) => OrdersNotifier(
    getOpenOrders: ref.watch(getOpenOrders),
    userDataStream: ref.watch(userDataStreamProvider),
  ),
);
final userDataStreamProvider = Provider<UserDataStream>((ref) => UserDataStream(getUserDataStream: ref.watch(getUserDataStream)));
final tickerStatsNotifierProvider = StateNotifierProvider<TickerStatsNotifier, TickerStatsState>(
  (ref) => TickerStatsNotifier(
    getLastTicker: ref.watch(getLastTicker),
    getTickerStatsStream: ref.watch(getTickerStatsStream),
  ),
);
final exchangeInfoNotifierProvider = StateNotifierProvider<ExchangeInfoNotifier, ExchangeInfoState>(
  (ref) => ExchangeInfoNotifier(getExchangeInfo: ref.watch(getExchangeInfo)),
);
final stateHandlerProvider = Provider<StateHandler>(
  (ref) => StateHandler(
    userDataStream: ref.watch(userDataStreamProvider),
    accountInfoNotifier: ref.watch(accountInfoNotifierProvider.notifier),
    ordersNotifier: ref.watch(ordersNotifierProvider.notifier),
    bookTickerNotifier: ref.watch(bookTickerNotifierProvider.notifier),
    tickerNotifier: ref.watch(tickerNotifierProvider.notifier),
    tickerStatsNotifier: ref.watch(tickerStatsNotifierProvider.notifier),
  ),
);
final authHandlerProvider = Provider<AuthHandler>((ref) => AuthHandler(checkAccountStatus: ref.watch(checkAccountStatus)));

// Use Cases
final getBookTickerStream = Provider<GetBookTickerStream>((ref) => GetBookTickerStream(ref.watch(marketRepositoryProvider)));
final getLastTicker = Provider<GetLastTicker>((ref) => GetLastTicker(ref.watch(userRepositoryProvider)));
final setLastTicker = Provider<SetLastTicker>((ref) => SetLastTicker(ref.watch(userRepositoryProvider)));
final getAccountInfo = Provider<GetAccountInfo>((ref) => GetAccountInfo(ref.watch(userRepositoryProvider)));
final getOpenOrders = Provider<GetOpenOrders>((ref) => GetOpenOrders(ref.watch(userRepositoryProvider)));
final getUserDataStream = Provider<GetUserDataStream>((ref) => GetUserDataStream(ref.watch(userRepositoryProvider)));
final getTickerStatsStream = Provider<GetTickerStatsStream>((ref) => GetTickerStatsStream(ref.watch(marketRepositoryProvider)));
final getExchangeInfo = Provider<GetExchangeInfo>((ref) => GetExchangeInfo(ref.watch(marketRepositoryProvider)));
final checkAccountStatus = Provider<CheckAccountStatus>((ref) => CheckAccountStatus(ref.watch(userRepositoryProvider)));
final postOrder = Provider<PostOrder>((ref) => PostOrder(ref.watch(tradeRepositoryProvider)));
final postCancelOrder = Provider<PostCancelOrder>((ref) => PostCancelOrder(ref.watch(tradeRepositoryProvider)));

// Repositories
final marketRepositoryProvider = Provider<MarketRepository>((ref) => MarketRepositoryImpl(ref.watch(marketDataSourceProvider)));
final tradeRepositoryProvider = Provider<TradeRepository>((ref) => TradeRepositoryImpl(ref.watch(tradeDataSourceProvider)));
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepositoryImpl(ref.watch(userDataSourceProvider)));

// Data Sources
final marketDataSourceProvider = Provider<MarketDataSource>(
  (ref) => MarketDataSourceImpl(
    dataSourceUtils: ref.watch(dataSourceUtilsProvider),
    httpClient: ref.watch(httpClientProvider),
  ),
);
final tradeDataSourceProvider = Provider<TradeDataSource>((ref) => TradeDataSourceImpl(ref.watch(httpClientProvider)));
final userDataSourceProvider = Provider<UserDataSource>(
  (ref) => UserDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
    httpClient: ref.watch(httpClientProvider),
    dataSourceUtils: ref.watch(dataSourceUtilsProvider),
  ),
);

// Core
final dataSourceUtilsProvider = Provider<DataSourceUtils>((ref) => DataSourceUtils());

// External
final httpClientProvider = Provider<http.Client>((ref) => http.Client());
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => sharedPreferencesInstance);
