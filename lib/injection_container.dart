import 'package:get_it/get_it.dart';
import 'package:price_action_orders/service_websocket.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<PaoWebSocket>(() => PaoWebSocket());
}