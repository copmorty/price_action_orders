import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/util/datasource_util.dart';
import 'package:price_action_orders/data/models/order_limit_model.dart';
import 'package:price_action_orders/data/models/order_market_model.dart';
import 'package:price_action_orders/data/models/order_response_full_model.dart';
import 'package:price_action_orders/domain/entities/order_limit.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';

abstract class OrderDataSource {
  Future<OrderResponseFull> postMarketOrder(MarketOrder marketOrder);
  Future<OrderResponseFull> postLimitOrder(LimitOrder limitOrder);
}

class OrderDataSourceImpl implements OrderDataSource {
  static const path = '/api/v3/order';
  final Client client;

  OrderDataSourceImpl({@required this.client});

  @override
  Future<OrderResponseFull> postMarketOrder(MarketOrder marketOrder) async {
    final params = MarketOrderModel.fromMarketOrder(marketOrder).toJson();

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
      final orderResponseFullModel = OrderResponseFullModel.fromStringifiedMap(response.body, marketOrder.ticker);
      return orderResponseFullModel;
    } else {
      throw ServerException.fromStringifiedMap(response.body);
    }
  }

  @override
  Future<OrderResponseFull> postLimitOrder(LimitOrder limitOrder) async {
    final params = LimitOrderModel.fromLimitOrder(limitOrder).toJson();

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
