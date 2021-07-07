import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocket;
import 'package:http/http.dart' as http;
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/utils/datasource_utils.dart';
import 'package:price_action_orders/data/models/order_model.dart';
import 'package:price_action_orders/data/models/userdata_model.dart';
import 'package:price_action_orders/data/models/userdata_payload_accountupdate_model.dart';
import 'package:price_action_orders/data/models/userdata_payload_orderupdate_model.dart';
import 'package:price_action_orders/domain/entities/order.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';

abstract class UserDataSource {
  Future<UserData> getAccountInfo();
  Future<List<Order>> getOpenOrders();
  Future<Stream<dynamic>> getUserDataStream();
}

class UserDataSourceImpl implements UserDataSource {
  final http.Client httpClient;
  final DataSourceUtils dataSourceUtils;
  WebSocket _webSocket;
  StreamController<dynamic> _streamController;
  Timer _timer;

  UserDataSourceImpl({
    this.httpClient,
    this.dataSourceUtils,
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

    if (_timer?.isActive ?? false) _timer.cancel();
    _webSocket?.close();
    _streamController?.close();
    _streamController = StreamController<dynamic>();

    _timer = dataSourceUtils.periodicValidityExpander(() => _extendListenKeyValidity(listenKey), _streamController);

    try {
      _webSocket = await dataSourceUtils.webSocketConnect(binanceWebSocketUrl + pathWS + listenKey);

      if (_webSocket.readyState == WebSocket.open) {
        _webSocket.listen(
          (data) {
            final Map jsonData = jsonDecode(data);
            dynamic finalData;

            if (jsonData['e'] == 'outboundAccountPosition') {
              finalData = UserDataPayloadAccountUpdateModel.fromJson(jsonData);
            } else if (jsonData['e'] == 'balanceUpdate') {
            } else if (jsonData['e'] == 'executionReport') {
              finalData = UserDataPayloadOrderUpdateModel.fromJson(jsonData);
            }

            if (finalData != null) _streamController.add(finalData);
          },
          onDone: () => print('[+] UserDataStream done.'),
          onError: (err) {
            print('[!] Error: ${err.toString()}');
            _streamController.addError(Error());
          },
          cancelOnError: true,
        );
      } else {
        print('[!] Connection denied.');
      }
    } catch (err) {
      _webSocket?.close();
      _streamController.close();
      if (_timer?.isActive ?? false) _timer.cancel();
      throw ServerException(message: "Could not obtain user data stream.");
    }

    return _streamController.stream;
  }
}
