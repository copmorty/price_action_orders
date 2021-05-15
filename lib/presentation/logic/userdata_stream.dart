import 'dart:async';

import 'package:price_action_orders/core/usecases/usecase.dart';
import 'package:price_action_orders/domain/usecases/get_userdata_stream.dart';
import 'package:meta/meta.dart';

class UserDataStream {
  final GetUserDataStream _getUserDataStream;
  StreamSubscription _subscription;
  StreamController<dynamic> _streamController = StreamController<dynamic>();

  UserDataStream({
    @required GetUserDataStream getUserDataStream,
    bool start = true,
  }) : _getUserDataStream = getUserDataStream {
    if (start) initialization();
  }

  Future<void> initialization() async {
    _subscription?.cancel();
    // _streamController?.close();
    // _streamController = StreamController<dynamic>();

    final failureOrStream = await _getUserDataStream(NoParams());
    failureOrStream.fold(
      (failure) => print('UserDataStream ERROR!!'),
      (stream) => _subscription = stream.listen((event) => _streamController.add(event)),
    );
  }

  Stream<dynamic> stream() => _streamController.stream;
}

// import 'dart:async';

// import 'package:price_action_orders/core/usecases/usecase.dart';
// import 'package:price_action_orders/domain/entities/userdata_payload_accountupdate.dart';
// import 'package:price_action_orders/domain/usecases/get_userdata_stream.dart';
// import 'package:price_action_orders/presentation/logic/userdata_state_notifier.dart';

// class UserDataStream {
//   final GetUserDataStream _getUserDataStream;
//   final UserDataNotifier _userDataNotifier;
//   StreamSubscription _subscription;

//   UserDataStream(this._getUserDataStream, this._userDataNotifier) {
//     startup();
//   }

//   Future<void> startup() async {
//     print('UserDataStream STARTUP!');
//     await _subscription?.cancel();

//     final failureOrStream = await _getUserDataStream(NoParams());
//     failureOrStream.fold(
//       (failure) => print('state = UserDataError(failure.message)'),
//       (stream) {
//         _subscription = stream.listen((event) => _dispatch(event));
//       },
//     );
//   }

//   void _dispatch(dynamic data) {
//     print('Im dispatching!!');
//     print('data is '+data.runtimeType.toString());
//     if (data is UserDataPayloadAccountUpdate) {
//       print('data is UserDataPayloadAccountUpdate');
//       _userDataNotifier.updateBalances(data);
//     }
//   }
// }
