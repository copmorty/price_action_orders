import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/data/datasources/bookticker_datasource.dart';
import 'package:price_action_orders/data/datasources/marketorder_datasource.dart';
import 'package:price_action_orders/data/repositories/bookticker_repository_impl.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';
import 'package:price_action_orders/domain/repositories/marketorder_repository.dart';
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';
import 'package:price_action_orders/domain/usecases/get_lastticker.dart';
import 'package:price_action_orders/domain/usecases/post_marketorder.dart';
import 'package:price_action_orders/domain/usecases/stream_bookticker.dart';
import 'package:price_action_orders/domain/usecases/get_userdata.dart';
import 'package:price_action_orders/domain/usecases/stream_userdata.dart';
import 'package:price_action_orders/presentation/bloc/bookticker_bloc.dart';
import 'package:price_action_orders/presentation/bloc/order_bloc.dart';
import 'package:price_action_orders/presentation/bloc/orderconfig_bloc.dart';
import 'package:price_action_orders/presentation/bloc/userdata_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/userdata_datasource.dart';
import 'data/repositories/marketorder_repository_impl.dart';
import 'data/repositories/userdata_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  // Blocs
  sl.registerFactory(() => BookTickerBloc(getLastTicker: sl(), streamBookTicker: sl(), orderConfigBloc: sl()));
  sl.registerFactory(() => UserDataBloc(getUserData: sl(), streamUserData: sl()));
  sl.registerFactory(() => OrderBloc(postMarketOrder: sl()));

  sl.registerLazySingleton(() => OrderConfigBloc());

  // Use cases
  sl.registerLazySingleton(() => GetLastTicker(sl()));
  sl.registerLazySingleton(() => StreamBookTicker(sl()));
  sl.registerLazySingleton(() => GetUserData(sl()));
  sl.registerLazySingleton(() => StreamUserData(sl()));
  sl.registerLazySingleton(() => PostMarketOrder(sl()));

  // Repositories
  sl.registerLazySingleton<BookTickerRepository>(
    () => BookTickerRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserDataRepository>(
    () => UserDataRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<MarketOrderRepository>(
    () => MarketOrderRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<BookTickerDataSource>(
    () => BookTickerDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UserDataDataSource>(
    () => UserDataDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<MarketOrderDataSource>(
    () => MarketOrderDataSourceImpl(client: sl()),
  );

  //! Core
  await loadKeys();

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<Client>(() => Client());
}

Future<void> loadKeys() async {
  final jsonStr = await rootBundle.loadString('assets/config.json');
  final data = jsonDecode(jsonStr);
  apiKey = data['api_key'];
  apiSecret = data['api_secret'];
}
