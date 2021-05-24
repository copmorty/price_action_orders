import 'dart:async';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/usecases/get_userdata_stream.dart';

class UserDataStream {
  final GetUserDataStream _getUserDataStream;
  StreamSubscription _subscription;
  StreamController<dynamic> _streamController = StreamController<dynamic>.broadcast();

  UserDataStream({
    @required GetUserDataStream getUserDataStream,
    bool start = true,
  }) : _getUserDataStream = getUserDataStream {
    if (start) initialization();
  }

  Future<void> initialization() async {
    _subscription?.cancel();

    final failureOrStream = await _getUserDataStream(NoParams());
    failureOrStream.fold(
      (failure) => print('UserDataStream ERROR!!'),
      (stream) => _subscription = stream.listen(
        (event) => _streamController.add(event),
        onError: (error) => _streamController.addError(error),
        cancelOnError: true,
      ),
    );
  }

  Stream<dynamic> stream() => _streamController.stream;
}
