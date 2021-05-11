import 'package:dartz/dartz.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';
import 'package:price_action_orders/domain/repositories/userdata_repository.dart';

class StreamUserData implements UseCase<Stream<UserDataPayloadAccountUpdate>, NoParams> {
  final UserDataRepository repository;

  StreamUserData(this.repository);

  @override
  Future<Either<ServerFailure, Stream<UserDataPayloadAccountUpdate>>> call(params) {
    return repository.streamUserData();
  }
}
