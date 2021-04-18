import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/util/datasource_util.dart';
import 'package:price_action_orders/data/models/order_market_model.dart';
import 'package:price_action_orders/data/models/order_response_full_model.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';

abstract class MarketOrderDataSource {
  Future<OrderResponseFull> postMarketOrder(MarketOrder marketOrder);
}

class MarketOrderDataSourceImpl implements MarketOrderDataSource {
  final Client client;

  MarketOrderDataSourceImpl({@required this.client});

  @override
  Future<OrderResponseFull> postMarketOrder(MarketOrder marketOrder) async {
    const path = '/api/v3/order';
    // Map<String, dynamic> params = {
    //   'timestamp': marketOrder.timestamp.toString(),
    //   'symbol': marketOrder.symbol,
    //   'side': marketOrder.side.toShortString(),
    //   'type': marketOrder.type.toShortString(),
    //   ...(marketOrder.quoteOrderQty == null
    //       ? {'quantity': marketOrder.quantity.toString()}
    //       : {'quoteOrderQty': marketOrder.quoteOrderQty.toString()}),
    // };
    MarketOrderModel marketOrderModel = MarketOrderModel.fromMarketOrder(marketOrder);
    final params = marketOrderModel.toJson();
    print('params');
    print(params);

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
      final orderResponseFullModel = OrderResponseFullModel.fromStringifiedMap(response.body);
      print(orderResponseFullModel.toJson().toString());
      return orderResponseFullModel;
    } else {
      throw ServerException.fromStringifiedMap(response.body);
    }
  }
}
