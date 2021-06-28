import 'package:equatable/equatable.dart';

class CacheException extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}

class ServerException extends Equatable implements Exception {
  final String message;

  ServerException({this.message});
  @override
  List<Object> get props => [message];
}

class BinanceException extends ServerException {
  BinanceException({message}) : super(message: message);

  factory BinanceException.fromJson(Map<String, dynamic> jsonData) {
    switch (jsonData['code']) {
      case -1001:
        return BinanceException(message: "Internal error, unable to process your request. Please try again.");
      case -1003:
        return BinanceException(message: "Too many requests.");
      case -1015:
        return BinanceException(message: "Too many new orders.");
      case -1111:
        return BinanceException(message: "Precision is over the maximum defined for this asset.");
      case -1112:
        return BinanceException(message: "No orders on book for symbol.");
      case -1121:
        return BinanceException(message: "Invalid symbol.");
      case -2010:
        return BinanceException(message: "New order rejected.");
      case -2011:
        return BinanceException(message: "Cancel order rejected.");
      case -2013:
        return BinanceException(message: "Order does not exist.");
      default:
        return BinanceException();
    }
  }
}
