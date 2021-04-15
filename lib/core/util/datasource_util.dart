import 'package:price_action_orders/core/globals/variables.dart';
import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

String generatetUrl({@required String path, @required Map<String, dynamic> params}) {
  String baseUrl = binanceTestUrl + path;
  String queryParams = generateQueryParams(params);
  // int timeStamp = DateTime.now().millisecondsSinceEpoch;
  // String queryParams = 'recvWindow=5000' + '&timestamp=' + timeStamp.toString();
  // queryParams = 'timestamp=' + timeStamp.toString() + queryParams;
  String secret = apiSecret;

  List<int> messageBytes = utf8.encode(queryParams);
  List<int> key = utf8.encode(secret);
  Hmac hmac = new Hmac(sha256, key);
  Digest digest = hmac.convert(messageBytes);
  String signature = hex.encode(digest.bytes);
  String url = baseUrl + '?' + queryParams + "&signature=" + signature;

  return url;
}

String generateQueryParams(Map<String, dynamic> params) {
  String queryParams = '';
  params.forEach((key, value) => queryParams += '&' + key + '=' + value);
  return queryParams.substring(1);
}
