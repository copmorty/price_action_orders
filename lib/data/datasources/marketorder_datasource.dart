import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/util/datasource_util.dart';
import 'package:price_action_orders/domain/entities/order_market.dart';

abstract class MarketOrderDataSource {
  Future<Either<Failure, dynamic>> postMarketOrder(MarketOrder marketOrder);
}

class MarketOrderDataSourceImpl implements MarketOrderDataSource {
  final Client client;
  final String path = '/api/v3/order';

  MarketOrderDataSourceImpl({@required this.client});

  @override
  Future<Either<Failure, dynamic>> postMarketOrder(MarketOrder marketOrder) async {
    // String symbol = baseAsset + quoteAsset;
    // int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = {
      'timestamp': marketOrder.timestamp.toString(),
      'symbol': marketOrder.symbol,
      'side': marketOrder.side.toShortString(),
      'type': marketOrder.type.toShortString(),
      ...(marketOrder.quoteOrderQty == null ? {'quantity': marketOrder.quantity.toString()} : {'quoteOrderQty': marketOrder.quoteOrderQty.toString()}),
    };

    String url = generatetUrl(path: path, params: params);

    final uri = Uri.parse(url);

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'X-MBX-APIKEY': apiKey,
      },
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return Right(response.body);
    } else {
      throw ServerException();
    }
  }
}
