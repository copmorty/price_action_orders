import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/data/models/userdata_model.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

abstract class UserDataDataSource {
  Future<UserData> getUserData();
}

class UserDataDataSourceImpl implements UserDataDataSource {
  final Client client;

  UserDataDataSourceImpl({@required this.client});

  @override
  Future<UserData> getUserData() async {
    final uri = Uri.parse(_getUrl());

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

  String _getUrl() {
    String baseUrl = 'https://testnet.binance.vision/api/v3/account?';
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    // String queryParams = 'recvWindow=5000' + '&timestamp=' + timeStamp.toString();
    String queryParams = 'timestamp=' + timeStamp.toString();
    String secret = apiSecret;

    List<int> messageBytes = utf8.encode(queryParams);
    List<int> key = utf8.encode(secret);
    Hmac hmac = new Hmac(sha256, key);
    Digest digest = hmac.convert(messageBytes);
    String signature = hex.encode(digest.bytes);
    String url = baseUrl + queryParams + "&signature=" + signature;

    return url;
  }
}
