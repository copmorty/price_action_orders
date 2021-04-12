import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/data/datasources/bookticker_datasource.dart';
import 'package:price_action_orders/data/repositories/bookticker_repository_impl.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';
import 'package:price_action_orders/domain/usecases/stream_bookticker.dart';
import 'package:price_action_orders/domain/usecases/get_userdata.dart';
import 'package:price_action_orders/presentation/bloc/bookticker_bloc.dart';
import 'package:price_action_orders/presentation/bloc/userdata_bloc.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'data/datasources/userdata_datasource.dart';
import 'data/repositories/userdata_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => BookTickerBloc(streamBookTicker: sl()));
  sl.registerFactory(() => UserDataBloc(getUserData: sl()));

  // Use cases
  sl.registerLazySingleton(() => StreamBookTicker(sl()));
  sl.registerLazySingleton(() => GetUserData(sl()));

  // Repository
  sl.registerLazySingleton<BookTickerRepository>(
    () => BookTickerRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<UserDataRepository>(
    () => UserDataRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<BookTickerDataSource>(
    () => BookTickerDataSourceImpl(),
  );
  sl.registerLazySingleton<UserDataDataSource>(
    () => UserDataDataSourceImpl(client: sl()),
  );

  await loadKeys();

  //! External
  sl.registerLazySingleton<Client>(() => Client());
}

Future<void> loadKeys() async {
  final jsonStr = await rootBundle.loadString('assets/config.json');
  final data = jsonDecode(jsonStr);
  apiKey = data['api_key'];
  apiSecret = data['api_secret'];
}
