part of 'auth_state_notifier.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final ApiAccess? testApiAccess;
  final ApiAccess? prodApiAccess;

  AuthLoaded({
    this.testApiAccess,
    this.prodApiAccess,
  });

  @override
  List<Object?> get props => [testApiAccess, prodApiAccess];
}
