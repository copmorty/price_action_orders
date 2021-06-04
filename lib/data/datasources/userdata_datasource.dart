import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocket;
import 'package:http/http.dart' as http;
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/utils/datasource_util.dart';
import 'package:price_action_orders/data/models/order_model.dart';
import 'package:price_action_orders/data/models/userdata_model.dart';
import 'package:price_action_orders/data/models/userdata_payload_accountupdate_model.dart';
import 'package:price_action_orders/data/models/userdata_payload_orderupdate_model.dart';
import 'package:price_action_orders/domain/entities/order.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';

abstract class UserDataDataSource {
  Future<UserData> getAccountInfo();
  Future<List<Order>> getOpenOrders();
  Future<Stream<dynamic>> getUserDataStream();
}

class UserDataDataSourceImpl implements UserDataDataSource {
  final http.Client client;
  WebSocket _webSocket;
  StreamController<dynamic> _streamController;
  Timer _timer;

  UserDataDataSourceImpl(this.client);

  _extendListenKeyValidity(String listenKey) async {
    const pathListenKey = '/api/v3/userDataStream';
    final queryParams = 'listenKey=' + listenKey;
    final uri = Uri.parse(binanceUrl + pathListenKey + '?' + queryParams);

    final response = await client.put(
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

    String url = generatetUrl(path: path, params: params);

    final uri = Uri.parse(url);

    final response = await client.get(
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
      print(jsonData);
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

    String url = generatetUrl(path: pathOpenOrders, params: params);

    final uri = Uri.parse(url);

    final response = await client.get(
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
      print(jsonData);
      throw BinanceException.fromJson(jsonData);
    }
  }

  @override
  Future<Stream<dynamic>> getUserDataStream() async {
    const pathListenKey = '/api/v3/userDataStream';
    const pathWS = '/ws/';

    final uri = Uri.parse(binanceUrl + pathListenKey);

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    if (response.statusCode != 200) throw ServerException();

    Map keyData = jsonDecode(response.body);
    final listenKey = keyData['listenKey'];

    _timer = Timer.periodic(Duration(minutes: 30), (timer) async {
      final int statusCode = await _extendListenKeyValidity(listenKey);
      if (statusCode != 200) {
        _streamController?.addError(ServerException(message: 'The UserData stream is not longer available.'));
        timer.cancel();
      }
    });

    _webSocket?.close();
    _streamController?.close();
    _streamController = StreamController<dynamic>();

    try {
      _webSocket = await WebSocket.connect(binanceWebSocketUrl + pathWS + listenKey);
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
          onError: (err) => print('[!] Error: ${err.toString()}'),
          cancelOnError: true,
        );
      } else {
        print('[!] Connection denied.');
      }
    } catch (err) {
      _webSocket?.close();
      _streamController.close();
      if (_timer.isActive) _timer.cancel();
      throw ServerException(message: "Could not obtain UserData stream.");
    }

    return _streamController.stream;
  }
}
