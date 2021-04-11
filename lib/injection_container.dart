import 'package:get_it/get_it.dart';
import 'package:price_action_orders/data/datasources/bookticker_datasource.dart';
import 'package:price_action_orders/data/repositories/bookticker_repository_impl.dart';
import 'package:price_action_orders/domain/repositories/bookticker_respository.dart';
import 'package:price_action_orders/domain/usecases/get_bookticker.dart';
import 'package:price_action_orders/presentation/bloc/bloc/bookticker_bloc.dart';

final sl = GetIt.instance;

Future<void> init() {
  // Bloc
  sl.registerFactory(() => BookTickerBloc(getBookTicker: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetBookTicker(sl()));

  // Repository
  sl.registerLazySingleton<BookTickerRepository>(
    () => BookTickerRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<BookTickerDataSource>(
    () => BookTickerDataSourceImpl(),
  );
}
