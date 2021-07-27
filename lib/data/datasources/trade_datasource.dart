import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/utils/datasource_utils.dart';
import 'package:price_action_orders/data/models/order_cancel_request_model.dart';
import 'package:price_action_orders/data/models/order_cancel_response_model.dart';
import 'package:price_action_orders/data/models/order_request_limit_model.dart';
import 'package:price_action_orders/data/models/order_request_market_model.dart';
import 'package:price_action_orders/data/models/order_request_stop_limit_model.dart';
import 'package:price_action_orders/data/models/order_response_full_model.dart';
import 'package:price_action_orders/domain/entities/order_cancel_request.dart';
import 'package:price_action_orders/domain/entities/order_cancel_response.dart';
import 'package:price_action_orders/domain/entities/order_request.dart';
import 'package:price_action_orders/domain/entities/order_request_limit.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/domain/entities/order_request_stop_limit.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';

abstract class TradeDataSource {
  Future<OrderResponseFull> postOrder(OrderRequest order);
  Future<CancelOrderResponse> postCancelOrder(CancelOrderRequest cancelOrder);
}

class TradeDataSourceImpl implements TradeDataSource {
  static const path = '/api/v3/order';
  final http.Client client;

  TradeDataSourceImpl(this.client);

  @override
  Future<OrderResponseFull> postOrder(OrderRequest order) async {
    late Map<String, dynamic> params;

    switch (order.runtimeType) {
      case LimitOrderRequest:
        params = LimitOrderRequestModel.fromLimitOrderRequest(order as LimitOrderRequest).toJson();
        break;
      case MarketOrderRequest:
        params = MarketOrderRequestModel.fromMarketOrderRequest(order as MarketOrderRequest).toJson();
        break;
      case StopLimitOrderRequest:
        params = StopLimitOrderRequestModel.fromStopLimitOrderRequest(order as StopLimitOrderRequest).toJson();
        break;
    }

    String url = DataSourceUtils.generatetUrl(path, params);

    final uri = Uri.parse(url);

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return OrderResponseFullModel.fromJson(jsonData, order.ticker);
    } else {
      // print(jsonData);
      throw BinanceException.fromJson(jsonData);
    }
  }

  Future<CancelOrderResponse> postCancelOrder(CancelOrderRequest cancelOrderRequest) async {
    final params = CancelOrderRequestModel.fromCancelOrderRequest(cancelOrderRequest).toJson();

    String url = DataSourceUtils.generatetUrl(path, params);
    final uri = Uri.parse(url);

    final response = await client.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    final jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return CancelOrderResponseModel.fromJson(jsonData);
    } else {
      // print(jsonData);
      throw BinanceException.fromJson(jsonData);
    }
  }
}
