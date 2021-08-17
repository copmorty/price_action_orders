import 'package:price_action_orders/core/globals/constants.dart';
import 'package:price_action_orders/core/globals/enums.dart';

late AppMode appMode;

late String binanceUrl;
late String binanceWebSocketUrl;

late String apiKey;
late String apiSecret;

int currentTickerPriceDecimalDigits = 8;
int currentTickerBaseVolumeDecimalDigits = 8;

void setGlobalModeVariables(AppMode mode, String key, String secret) {
  appMode = mode;
  apiKey = key;
  apiSecret = secret;
  binanceUrl = appMode == AppMode.PRODUCTION ? BINANCE_REAL_URL : BINANCE_TEST_URL;
  binanceWebSocketUrl = appMode == AppMode.PRODUCTION ? BINANCE_REAL_WEBSOCKET_URL : BINANCE_TEST_WEBSOCKET_URL;
}
