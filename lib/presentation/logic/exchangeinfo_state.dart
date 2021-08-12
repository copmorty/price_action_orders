part of 'exchangeinfo_state_notifier.dart';

abstract class ExchangeInfoState extends Equatable {
  const ExchangeInfoState();

  @override
  List<Object> get props => [];
}

class ExchangeInfoInitial extends ExchangeInfoState {}

class ExchangeInfoLoading extends ExchangeInfoState {}

class ExchangeInfoLoaded extends ExchangeInfoState {
  final ExchangeInfo exchangeInfo;

  ExchangeInfoLoaded(this.exchangeInfo);

  @override
  List<Object> get props => [exchangeInfo];
}

class ExchangeInfoError extends ExchangeInfoState {
  final String message;

  ExchangeInfoError(this.message);

  @override
  List<Object> get props => [message];
}
