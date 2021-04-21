import 'package:price_action_orders/core/globals/constants.dart';
import 'package:price_action_orders/core/globals/enums.dart';

AppMode appMode = AppMode.PRODUCTION;

String binanceUrl = appMode == AppMode.PRODUCTION ? BINANCE_REAL_URL : BINANCE_TEST_URL;
String binanceWebSocketUrl = appMode == AppMode.PRODUCTION ? BINANCE_REAL_WEBSOCKET_URL : BINANCE_TEST_WEBSOCKET_URL;

String apiKey = 'YOUR-API-KEY-HERE';
String apiSecret = 'YOUR-API-SECRET-HERE';
