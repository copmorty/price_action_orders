import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  dynamic call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
