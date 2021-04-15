import 'dart:convert';

class ServerException implements Exception {
  final String message;

  ServerException({this.message});

  factory ServerException.fromStringifiedMap(String strMap) {
    final Map data = jsonDecode(strMap);

    return ServerException(message: data['msg']);
  }
}

class CacheException implements Exception {}
