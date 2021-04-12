import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/data/models/userdata_model.dart';
import 'package:price_action_orders/domain/entities/userdata.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

// TESTNET
const API_KEY = 'VHQj71iYTxjKnU8KdKYowjLBxPIUtorEj9H03PvAdnq86QWrcH2Nq7BrCyyRxPRe';
const API_SECRET = 'Rugzw03nRPOhPW6rrfqm2CwNqRj6CysAg9ytnu1sYdQgxBhGdX8vacCOIHOW9B9N';

abstract class UserDataDataSource {
  Future<UserData> getUserData();
}

class UserDataDataSourceImpl implements UserDataDataSource {
  final Client client;

  UserDataDataSourceImpl({@required this.client});

  @override
  Future<UserData> getUserData() async {
    String baseUrl = 'https://testnet.binance.vision/api/v3/account?';
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    // String queryParams = 'recvWindow=5000' + '&timestamp=' + timeStamp.toString();
    String queryParams = 'timestamp=' + timeStamp.toString();
    String secret = API_SECRET;

    List<int> messageBytes = utf8.encode(queryParams);
    List<int> key = utf8.encode(secret);
    Hmac hmac = new Hmac(sha256, key);
    Digest digest = hmac.convert(messageBytes);
    String signature = hex.encode(digest.bytes);
    String url = baseUrl + queryParams + "&signature=" + signature;
    final uri = Uri.parse(url);

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': API_KEY,
      },
    );
    
    if (response.statusCode == 200) {
      return UserDataModel.fromStringifiedMap(response.body);
    } else {
      throw ServerException();
    }
  }
}
