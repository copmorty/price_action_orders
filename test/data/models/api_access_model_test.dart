import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:price_action_orders/data/models/api_access_model.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import '../../attachments/attachment_reader.dart';

void main() {
  final tApiAccess = ApiAccess(key: 'qwerty', secret: 'asdfgh');
  final tApiAccessModel = ApiAccessModel(key: 'qwerty', secret: 'asdfgh');

  test(
    'should be a subclass of ApiAccess',
    ()  {
      //assert
      expect(tApiAccessModel, isA<ApiAccess>());
    },
  );

  test(
    'fromApiAccess should return a valid ApiAccessModel',
    ()  {
      //act
      final result = ApiAccessModel.fromApiAccess(tApiAccess);
      //assert
      expect(result, tApiAccessModel);
    },
  );

  test(
    'fromJson should return a valid ApiAccessModel',
    () async {
      //arrange
      final Map<String, dynamic> parsedJson = jsonDecode(attachment('api_access.json'));
      //act
      final result = ApiAccessModel.fromJson(parsedJson);
      //assert
      expect(result, tApiAccessModel);
    },
  );

  test(
    'toJson should return a Json map containing the proper data',
    () {
      //act
      final result = tApiAccessModel.toJson();
      //assert
      final expectedMap = {
        'key': 'qwerty',
        'secret': 'asdfgh',
      };

      expect(result, expectedMap);
    },
  );
}
