import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/data/models/order_cancel_request_model.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';

void main() {
  final tCancelOrderRequest = CancelOrderRequest(symbol: 'BNBUSDT', orderId: 12378);
  final tCancelOrderRequestModel = CancelOrderRequestModel(symbol: 'BNBUSDT', orderId: 12378);

  test(
    'should be a subclass of CancelOrderRequest',
    () {
      //assert
      expect(tCancelOrderRequestModel, isA<CancelOrderRequest>());
    },
  );

  test(
    'fromCancelOrderRequest should return a valid CancelOrderRequestModel',
    () {
      //act
      final result = CancelOrderRequestModel.fromCancelOrderRequest(tCancelOrderRequest);
      //assert
      expect(result, tCancelOrderRequestModel);
    },
  );

  test(
    'toJson should return a Json map containing the proper data',
    () async {
      //act
      final result = tCancelOrderRequestModel.toJson();
      //assert
      final expectedMap = {
        'symbol': 'BNBUSDT',
        'orderId': '12378',
        'timestamp': isA<String>(),
      };

      expect(result, expectedMap);
    },
  );
}
