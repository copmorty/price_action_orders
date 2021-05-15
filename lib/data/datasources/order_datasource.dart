import 'package:http/http.dart' as http;
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/utils/datasource_util.dart';
import 'package:price_action_orders/data/models/order_request_limit_model.dart';
import 'package:price_action_orders/data/models/order_request_market_model.dart';
import 'package:price_action_orders/data/models/order_response_full_model.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';

abstract class OrderDataSource {
  Future<OrderResponseFull> postMarketOrder(MarketOrderRequest marketOrder);
  Future<OrderResponseFull> postLimitOrder(LimitOrderRequest limitOrder);
}

class OrderDataSourceImpl implements OrderDataSource {
  static const path = '/api/v3/order';
  final http.Client client;

  OrderDataSourceImpl(this.client);

  @override
  Future<OrderResponseFull> postMarketOrder(MarketOrderRequest marketOrder) async {
    final params = MarketOrderRequestModel.fromMarketOrderRequest(marketOrder).toJson();

    String url = generatetUrl(path: path, params: params);

    final uri = Uri.parse(url);

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final orderResponseFullModel = OrderResponseFullModel.fromStringifiedMap(response.body, marketOrder.ticker);
      return orderResponseFullModel;
    } else {
      throw ServerException.fromStringifiedMap(response.body);
    }
  }

  @override
  Future<OrderResponseFull> postLimitOrder(LimitOrderRequest limitOrder) async {
    final params = LimitOrderRequestModel.fromLimitOrderRequest(limitOrder).toJson();

    String url = generatetUrl(path: path, params: params);

    final uri = Uri.parse(url);

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final orderResponseFullModel = OrderResponseFullModel.fromStringifiedMap(response.body, limitOrder.ticker);
      return orderResponseFullModel;
    } else {
      throw ServerException.fromStringifiedMap(response.body);
    }
  }
}
