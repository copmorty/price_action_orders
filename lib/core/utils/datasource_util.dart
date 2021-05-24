import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:price_action_orders/core/globals/variables.dart';

String generatetUrl({@required String path, @required Map<String, dynamic> params}) {
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

String generateQueryParams(Map<String, dynamic> params) {
  String queryParams = '';
  params.forEach((key, value) => queryParams += '&' + key + '=' + value);
  return queryParams.substring(1);
}
