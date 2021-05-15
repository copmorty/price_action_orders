import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:price_action_orders/domain/usecases/get_userdata_openorders.dart';
import 'package:price_action_orders/presentation/logic/userdata_stream.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/globals/enums.dart';
import 'core/globals/variables.dart';
import 'data/datasources/bookticker_datasource.dart';
import 'data/datasources/order_datasource.dart';
import 'data/datasources/userdata_datasource.dart';
import 'data/repositories/bookticker_repository_impl.dart';
import 'data/repositories/order_repository_impl.dart';
import 'data/repositories/userdata_repository_impl.dart';
import 'domain/repositories/bookticker_respository.dart';
import 'domain/repositories/order_repository.dart';
import 'domain/repositories/userdata_repository.dart';
import 'domain/usecases/get_lastticker.dart';
import 'domain/usecases/get_userdata_accountinfo.dart';
import 'domain/usecases/post_limitorder.dart';
import 'domain/usecases/post_marketorder.dart';
import 'domain/usecases/get_bookticker_stream.dart';
import 'domain/usecases/get_userdata_stream.dart';
import 'presentation/logic/bookticker_state_notifier.dart';
import 'presentation/logic/orderrequest_state_notifier.dart';
import 'presentation/logic/orderconfig_state_notifier.dart';
// import 'presentation/logic/userdata_state_notifier.dart';
import 'presentation/logic/accountinfo_state_notifier.dart';

SharedPreferences sharedPreferencesInstance;

Future<void> init() async {
  await loadKeys();
  sharedPreferencesInstance = await SharedPreferences.getInstance();
}

Future<void> loadKeys() async {
  final location = appMode == AppMode.PRODUCTION ? 'assets/config-prod.json' : 'assets/config-test.json';
  final jsonStr = await rootBundle.loadString(location);
  final data = jsonDecode(jsonStr);
  apiKey = data['api_key'];
  apiSecret = data['api_secret'];
}

// Logic
final bookTickerNotifierProvider = StateNotifierProvider<BookTickerNotifier, BookTickerState>(
  (ref) => BookTickerNotifier(
    getLastTicker: ref.watch(getLastTickerProvider),
    getBookTickerStream: ref.watch(getBookTickerStream),
    orderConfigNotifier: ref.watch(orderConfigNotifierProvider.notifier),
  ),
);
final orderRequestNotifierProvider = StateNotifierProvider<OrderRequestNotifier, OrderRequestState>(
  (ref) => OrderRequestNotifier(
    postLimitOrder: ref.watch(postLimitOder),
    postMarketOrder: ref.watch(postMarketOrder),
  ),
);
final orderConfigNotifierProvider = StateNotifierProvider<OrderConfigNotifier, OrderConfigState>((ref) => OrderConfigNotifier());
final accountInfoNotifierProvider = StateNotifierProvider<AccountInfoNotifier, AccountInfoState>((ref) => AccountInfoNotifier(
      getAccountInfo: ref.watch(getAccountInfo),
      userDataStream: ref.watch(userDataStream),
    ));
// final userDataNotifierProvider = StateNotifierProvider<UserDataNotifier, UserDataState>(
//   (ref) => UserDataNotifier(
//     getUserData: ref.watch(getAccountInfo),
//     streamUserData: ref.watch(getUserDataStream),
//   ),
// );
final userDataStream = Provider<UserDataStream>((ref) => UserDataStream(getUserDataStream: ref.watch(getUserDataStream)));

// Use Cases
final getBookTickerStream = Provider<GetBookTickerStream>((ref) => GetBookTickerStream(ref.watch(bookTickerRepositoryProvider)));
final getLastTickerProvider = Provider<GetLastTicker>((ref) => GetLastTicker(ref.watch(bookTickerRepositoryProvider)));
final getAccountInfo = Provider<GetAccountInfo>((ref) => GetAccountInfo(ref.watch(userDataRepositoryProvider)));
final getOpenOrders = Provider<GetOpenOrders>((ref) => GetOpenOrders(ref.watch(userDataRepositoryProvider)));
final getUserDataStream = Provider<GetUserDataStream>((ref) => GetUserDataStream(ref.watch(userDataRepositoryProvider)));
final postLimitOder = Provider<PostLimitOrder>((ref) => PostLimitOrder(ref.watch(orderRepositoryProvider)));
final postMarketOrder = Provider<PostMarketOrder>((ref) => PostMarketOrder(ref.watch(orderRepositoryProvider)));

// Repositories
final bookTickerRepositoryProvider = Provider<BookTickerRepository>((ref) => BookTickerRepositoryImpl(ref.watch(bookTickerProvider)));
final orderRepositoryProvider = Provider<OrderRepository>((ref) => OrderRepositoryImpl(ref.watch(orderDataSourceProvider)));
final userDataRepositoryProvider = Provider<UserDataRepository>((ref) => UserDataRepositoryImpl(ref.watch(userDataSourceProvider)));

// Data Sources
final bookTickerProvider = Provider<BookTickerDataSource>((ref) => BookTickerDataSourceImpl(ref.watch(sharedPreferencesProvider)));
final orderDataSourceProvider = Provider<OrderDataSource>((ref) => OrderDataSourceImpl(ref.watch(httpClientProvider)));
final userDataSourceProvider = Provider<UserDataDataSource>((ref) => UserDataDataSourceImpl(ref.watch(httpClientProvider)));

// External
final httpClientProvider = Provider<http.Client>((ref) => http.Client());
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => sharedPreferencesInstance);
