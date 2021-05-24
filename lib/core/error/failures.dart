import 'package:equatable/equatable.dart';
import 'exceptions.dart';

abstract class Failure extends Equatable {
  final String message = 'Something went wrong.';
}

class ServerFailure extends Failure {
  @override
  final String message;

  ServerFailure({this.message});

  factory ServerFailure.fromException(Exception e) {
    if (e is ServerException && e.message != null) {
      return ServerFailure(message: e.message);
    }
    return ServerFailure();
  }

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  @override
  List<Object> get props => [];
}
