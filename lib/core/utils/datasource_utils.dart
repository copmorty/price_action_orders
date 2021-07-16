import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';

class DataSourceUtils {
  static String generateQueryParams(Map<String, dynamic> params) {
    String queryParams = '';
    params.forEach((key, value) => queryParams += '&' + key + '=' + value);
    return queryParams.substring(1);
  }

  static String generatetUrl(String path, Map<String, dynamic> params) {
    String baseUrl = binanceUrl + path;
    String queryParams = generateQueryParams(params);
    String secret = apiSecret;

    List<int> messageBytes = utf8.encode(queryParams);
    List<int> key = utf8.encode(secret);
    Hmac hmac = new Hmac(sha256, key);
    Digest digest = hmac.convert(messageBytes);
    String signature = hex.encode(digest.bytes);
    String url = baseUrl + '?' + queryParams + "&signature=" + signature;

    return url;
  }

  Timer periodicValidityExpander(Function listenKeyValidityExpander, StreamController<dynamic> streamController) =>
      Timer.periodic(Duration(minutes: 30), (timer) async {
        final int statusCode = await listenKeyValidityExpander();
        if (statusCode != 200) {
          streamController?.addError(ServerException(message: 'The UserData stream is not longer available.'));
          timer.cancel();
        }
      });

  Future<WebSocket> webSocketConnect(
    String url, {
    Iterable<String> protocols,
    Map<String, dynamic> headers,
    CompressionOptions compression = CompressionOptions.compressionDefault,
  }) =>
      WebSocket.connect(url, protocols: protocols, headers: headers, compression: compression);
}
