// import 'dart:convert';
// import 'package:get_it/get_it.dart';
// import 'package:price_action_orders/core/globals/enums.dart';
// import 'package:price_action_orders/core/globals/variables.dart';
// import 'package:price_action_orders/data/datasources/bookticker_datasource.dart';
// import 'package:price_action_orders/data/datasources/order_datasource.dart';
// import 'package:price_action_orders/data/repositories/bookticker_repository_impl.dart';
// import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';
// import 'package:price_action_orders/domain/repositories/order_repository.dart';
// import 'package:price_action_orders/domain/repositories/userdata_repository.dart';
// import 'package:price_action_orders/domain/usecases/get_lastticker.dart';
// import 'package:price_action_orders/domain/usecases/post_limitorder.dart';
// import 'package:price_action_orders/domain/usecases/post_marketorder.dart';
// import 'package:price_action_orders/domain/usecases/stream_bookticker.dart';
// import 'package:price_action_orders/domain/usecases/get_userdata.dart';
// import 'package:price_action_orders/domain/usecases/stream_userdata.dart';
// import 'package:price_action_orders/presentation/bloc/bookticker_bloc.dart';
// import 'package:price_action_orders/presentation/bloc/order_bloc.dart';
// import 'package:price_action_orders/presentation/bloc/orderconfig_bloc.dart';
// import 'package:price_action_orders/presentation/bloc/userdata_bloc.dart';
// import 'package:http/http.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:shared_preferences/shared_preferences.dart';

// import 'data/datasources/userdata_datasource.dart';
// import 'data/repositories/order_repository_impl.dart';
// import 'data/repositories/userdata_repository_impl.dart';

// final sl = GetIt.instance;

// Future<void> init() async {
//   //! Features
//   // Blocs
//   sl.registerFactory(() => BookTickerBloc(getLastTicker: sl(), streamBookTicker: sl(), orderConfigBloc: sl()));
//   sl.registerFactory(() => UserDataBloc(getUserData: sl(), streamUserData: sl()));
//   sl.registerFactory(() => OrderBloc(postLimitOrder: sl(),postMarketOrder: sl()));

//   sl.registerLazySingleton(() => OrderConfigBloc());

//   // Use cases
//   sl.registerLazySingleton(() => GetLastTicker(sl()));
//   sl.registerLazySingleton(() => StreamBookTicker(sl()));
//   sl.registerLazySingleton(() => GetUserData(sl()));
//   sl.registerLazySingleton(() => StreamUserData(sl()));
//   sl.registerLazySingleton(() => PostMarketOrder(sl()));
//   sl.registerLazySingleton(() => PostLimitOrder(sl()));

//   // Repositories
//   sl.registerLazySingleton<BookTickerRepository>(
//     () => BookTickerRepositoryImpl(dataSource: sl()),
//   );
//   sl.registerLazySingleton<UserDataRepository>(
//     () => UserDataRepositoryImpl(dataSource: sl()),
//   );
//   sl.registerLazySingleton<OrderRepository>(
//     () => OrderRepositoryImpl(dataSource: sl()),
//   );

//   // Data sources
//   sl.registerLazySingleton<BookTickerDataSource>(
//     () => BookTickerDataSourceImpl(sl()),
//   );
//   sl.registerLazySingleton<UserDataDataSource>(
//     () => UserDataDataSourceImpl(client: sl()),
//   );
//   sl.registerLazySingleton<OrderDataSource>(
//     () => OrderDataSourceImpl(client: sl()),
//   );

//   //! Core
//   await loadKeys();

//   //! External
//   final sharedPreferences = await SharedPreferences.getInstance();
//   sl.registerLazySingleton(() => sharedPreferences);
//   sl.registerLazySingleton<Client>(() => Client());
// }

// Future<void> loadKeys() async {
//   final location = appMode == AppMode.PRODUCTION ? 'assets/config-prod.json' : 'assets/config-test.json';
//   final jsonStr = await rootBundle.loadString(location);
//   final data = jsonDecode(jsonStr);
//   apiKey = data['api_key'];
//   apiSecret = data['api_secret'];
// }
