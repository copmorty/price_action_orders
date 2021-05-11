import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
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
import 'domain/usecases/get_userdata.dart';
import 'domain/usecases/post_limitorder.dart';
import 'domain/usecases/post_marketorder.dart';
import 'domain/usecases/stream_bookticker.dart';
import 'domain/usecases/stream_userdata.dart';
import 'presentation/logic/bookticker_state_notifier.dart';
import 'presentation/logic/order_state_notifier.dart';
import 'presentation/logic/orderconfig_state_notifier.dart';
import 'presentation/logic/userdata_state_notifier.dart';

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
    streamBookTicker: ref.watch(streamBookTicker),
    orderConfigNotifier: ref.watch(orderConfigNotifierProvider.notifier),
  ),
);
final orderNotifierProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(
    postLimitOrder: ref.watch(postLimitOder),
    postMarketOrder: ref.watch(postMarketOrder),
  ),
);
final orderConfigNotifierProvider = StateNotifierProvider<OrderConfigNotifier, OrderConfigState>((ref) => OrderConfigNotifier());
final userDataNotifierProvider = StateNotifierProvider<UserDataNotifier, UserDataState>(
  (ref) => UserDataNotifier(
    getUserData: ref.watch(getUserData),
    streamUserData: ref.watch(streamUserData),
  ),
);

// Use Cases
final getLastTickerProvider = Provider<GetLastTicker>((ref) => GetLastTicker(ref.watch(bookTickerRepositoryProvider)));
final getUserData = Provider<GetUserData>((ref) => GetUserData(ref.watch(userDataRepositoryProvider)));
final postLimitOder = Provider<PostLimitOrder>((ref) => PostLimitOrder(ref.watch(orderRepositoryProvider)));
final postMarketOrder = Provider<PostMarketOrder>((ref) => PostMarketOrder(ref.watch(orderRepositoryProvider)));
final streamBookTicker = Provider<StreamBookTicker>((ref) => StreamBookTicker(ref.watch(bookTickerRepositoryProvider)));
final streamUserData = Provider<StreamUserData>((ref) => StreamUserData(ref.watch(userDataRepositoryProvider)));

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
