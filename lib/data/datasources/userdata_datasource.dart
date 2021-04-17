import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocket;
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/util/datasource_util.dart';
import 'package:price_action_orders/data/models/userdata_model.dart';
import 'package:price_action_orders/data/models/userdata_payload_accountupdate_model.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';

abstract class UserDataDataSource {
  Future<UserData> getUserData();
  Future<Stream<UserDataPayloadAccountUpdate>> streamUserData();
}

class UserDataDataSourceImpl implements UserDataDataSource {
  final Client client;
  final StreamController<UserDataPayloadAccountUpdate> _streamController = StreamController<UserDataPayloadAccountUpdate>();
  Timer _timer;

  UserDataDataSourceImpl({@required this.client});

  @override
  Future<UserData> getUserData() async {
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

    if (response.statusCode == 200) {
      return UserDataModel.fromStringifiedMap(response.body);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Stream<UserDataPayloadAccountUpdate>> streamUserData() async {
    // print('datasources: streamUserData()');
    const pathListenKey = '/api/v3/userDataStream';
    const pathWS = '/ws/';

    final uri = Uri.parse(binanceTestUrl + pathListenKey);

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
      // print(DateTime.now());
      final int statusCode = await _extendListenKeyValidity(listenKey);
      if (statusCode != 200) {
        print('SOMETHING WENT WRONG');
        throw ServerException();//NEEDS IMPLEMENTATION
      }
    });

    WebSocket.connect(binanceTestWebSocketUrl + pathWS + listenKey).then(
      (WebSocket ws) {
        if (ws?.readyState == WebSocket.open) {
          ws.listen(
            (data) => _onData(data),
            onDone: _onDone,
            onError: (err) => _onError(err),
            cancelOnError: true,
          );
        } else {
          print('[!]Connection Denied');
        }
      },
    ).catchError((err) {
      print(err);
      _streamController.close();
      if (_timer.isActive) _timer.cancel();
      throw ServerException();
    });

    return _streamController.stream;
  }

  _onData(data) {
    // print(data);
    final Map jsonData = jsonDecode(data);
    if (jsonData['e'] == 'outboundAccountPosition') {
      final userDataPayloadAccountUpdate = UserDataPayloadAccountUpdateModel.fromJson(jsonData);
      _streamController.add(userDataPayloadAccountUpdate);
    }
  }

  _onDone() {
    print('[+]Done :)');
  }

  _onError(err) {
    print('[!]Error -- ${err.toString()}');
  }

  _extendListenKeyValidity(String listenKey) async {
    const pathListenKey = '/api/v3/userDataStream';
    final queryParams = 'listenKey=' + listenKey;
    final uri = Uri.parse(binanceTestUrl + pathListenKey + '?' + queryParams);

    final response = await client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    return response.statusCode;
  }
}
