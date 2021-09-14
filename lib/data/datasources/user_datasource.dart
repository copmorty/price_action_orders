import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocket;
import 'package:decimal/decimal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/constants.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/utils/datasource_utils.dart';
import 'package:price_action_orders/data/models/api_access_model.dart';
import 'package:price_action_orders/data/models/order_model.dart';
import 'package:price_action_orders/data/models/order_request_market_model.dart';
import 'package:price_action_orders/data/models/ticker_model.dart';
import 'package:price_action_orders/data/models/userdata_model.dart';
import 'package:price_action_orders/data/models/userdata_payload_accountupdate_model.dart';
import 'package:price_action_orders/data/models/userdata_payload_orderupdate_model.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import 'package:price_action_orders/domain/entities/order.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserDataSource {
  Future<UserData> getAccountInfo();
  Future<List<Order>> getOpenOrders();
  Future<Stream<dynamic>> getUserDataStream();
  Future<void> cacheLastTicker(Ticker ticker);
  Future<Ticker> getLastTicker();
  Future<Null> checkAccountStatus(AppMode mode, String key, String secret);
  Future<Null> storeApiAccess(AppMode mode, ApiAccess apiAccess);
  Future<ApiAccess> getApiAccess(AppMode mode);
  Future<Null> clearApiAccess(AppMode mode);
}

class UserDataSourceImpl implements UserDataSource {
  final SharedPreferences sharedPreferences;
  final http.Client httpClient;
  final DataSourceUtils dataSourceUtils;
  final FlutterSecureStorage secureStorage;
  WebSocket? _webSocket;
  StreamController<dynamic>? _streamController;
  Timer? _timer;

  UserDataSourceImpl({
    required this.sharedPreferences,
    required this.httpClient,
    required this.dataSourceUtils,
    required this.secureStorage,
  });

  _extendListenKeyValidity(String listenKey) async {
    const pathListenKey = '/api/v3/userDataStream';
    final queryParams = 'listenKey=' + listenKey;
    final uri = Uri.parse(binanceUrl + pathListenKey + '?' + queryParams);

    final response = await httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    return response.statusCode;
  }

  @override
  Future<UserData> getAccountInfo() async {
    const path = '/api/v3/account';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = {
      'timestamp': timestamp.toString(),
    };

    String url = DataSourceUtils.generatetUrl(path, params);

    final uri = Uri.parse(url);

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserDataModel.fromJson(jsonData);
    } else {
      // print(jsonData);
      throw BinanceException.fromJson(jsonData);
    }
  }

  @override
  Future<List<Order>> getOpenOrders() async {
    const pathOpenOrders = '/api/v3/openOrders';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = {
      'timestamp': timestamp.toString(),
    };

    String url = DataSourceUtils.generatetUrl(pathOpenOrders, params);

    final uri = Uri.parse(url);

    final response = await httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonData;
      final List<OrderModel> openOrders = [];
      data.forEach((element) {
        openOrders.add(OrderModel.fromJson(element));
      });

      return openOrders;
    } else {
      // print(jsonData);
      throw BinanceException.fromJson(jsonData);
    }
  }

  @override
  Future<Stream<dynamic>> getUserDataStream() async {
    const pathListenKey = '/api/v3/userDataStream';
    const pathWS = '/ws/';

    final uri = Uri.parse(binanceUrl + pathListenKey);

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    if (response.statusCode != 200) throw ServerException();

    Map keyData = jsonDecode(response.body);
    final listenKey = keyData['listenKey'];

    if (_timer?.isActive ?? false) _timer!.cancel();
    _webSocket?.close();
    _streamController?.close();
    _streamController = StreamController<dynamic>();

    _timer = dataSourceUtils.periodicValidityExpander(() => _extendListenKeyValidity(listenKey), _streamController);

    try {
      _webSocket = await dataSourceUtils.webSocketConnect(binanceWebSocketUrl + pathWS + listenKey);

      if (_webSocket!.readyState == WebSocket.open) {
        _webSocket!.listen(
          (data) {
            final Map<String, dynamic> jsonData = jsonDecode(data);
            dynamic finalData;

            if (jsonData['e'] == 'outboundAccountPosition') {
              finalData = UserDataPayloadAccountUpdateModel.fromJson(jsonData);
            } else if (jsonData['e'] == 'balanceUpdate') {
            } else if (jsonData['e'] == 'executionReport') {
              finalData = UserDataPayloadOrderUpdateModel.fromJson(jsonData);
            }

            if (finalData != null) _streamController!.add(finalData);
          },
          onDone: () => print('[+] UserDataStream done.'),
          onError: (err) {
            print('[!] Error: ${err.toString()}');
            _streamController!.addError(Error());
          },
          cancelOnError: true,
        );
      } else {
        print('[!] Connection denied.');
      }
    } catch (err) {
      _webSocket?.close();
      _streamController!.close();
      if (_timer?.isActive ?? false) _timer!.cancel();
      throw ServerException(message: "Could not obtain user data stream.");
    }

    return _streamController!.stream;
  }

  @override
  Future<Ticker> getLastTicker() async {
    final jsonString = sharedPreferences.getString(LAST_TICKER);
    if (jsonString == null) {
      throw CacheException();
    } else {
      return TickerModel.fromJson(jsonDecode(jsonString));
    }
  }

  @override
  Future<void> cacheLastTicker(Ticker ticker) async {
    final tickerModel = TickerModel.fromTicker(ticker);
    await sharedPreferences.setString(
      LAST_TICKER,
      jsonEncode(tickerModel.toJson()),
    );
  }

  @override
  Future<Null> checkAccountStatus(AppMode mode, String key, String secret) async {
    // const path = '/sapi/v1/account/status'; // NOT AVAILABLE (FOR NOW) WITH THE TESTNET API
    const path = '/api/v3/order/test';

    final marketOrder = MarketOrderRequestModel(
      ticker: Ticker(baseAsset: 'BTC', quoteAsset: 'USDT'),
      side: BinanceOrderSide.BUY,
      quoteOrderQty: Decimal.parse('20'),
    );

    final Map<String, dynamic> params = marketOrder.toJson();
    final middleUrl = mode == AppMode.PRODUCTION ? BINANCE_REAL_URL : BINANCE_TEST_URL;

    String url = DataSourceUtils.generatetUrl(path, params, middleUrl: middleUrl, secret: secret);

    final uri = Uri.parse(url);

    final response = await httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': key,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return null;
    } else {
      // print(jsonData);
      throw BinanceException.fromJson(jsonData);
    }
  }

  @override
  Future<Null> storeApiAccess(AppMode mode, ApiAccess apiAccess) async {
    final apiAccessModel = ApiAccessModel.fromApiAccess(apiAccess);
    await secureStorage.write(
      key: mode.toShortString(),
      value: jsonEncode(apiAccessModel.toJson()),
    );
  }

  @override
  Future<ApiAccess> getApiAccess(AppMode mode) async {
    final jsonString = await secureStorage.read(key: mode.toShortString());

    if (jsonString == null) {
      throw CacheException();
    } else {
      return ApiAccessModel.fromJson(jsonDecode(jsonString));
    }
  }

  @override
  Future<Null> clearApiAccess(AppMode mode) async {
    await secureStorage.delete(key: mode.toShortString());
  }
}
