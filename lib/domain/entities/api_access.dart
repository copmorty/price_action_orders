import 'package:equatable/equatable.dart';

class ApiAccess extends Equatable {
  final String key;
  final String secret;

  ApiAccess({
    required this.key,
    required this.secret,
  });

  @override
  List<Object> get props => [key, secret];
}
