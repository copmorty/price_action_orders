import 'exceptions.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure({String? message}) : this.message = message ?? 'Something went wrong.';

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {}

class ServerFailure extends Failure {
  ServerFailure({String? message}) : super(message: message);

  factory ServerFailure.fromException(Object e) {
    if (e is ServerException && e.message != null) {
      return ServerFailure(message: e.message);
    }
    return ServerFailure();
  }
}
