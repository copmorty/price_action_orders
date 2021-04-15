import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:price_action_orders/core/error/exceptions.dart';
import 'package:price_action_orders/core/error/failures.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/core/util/datasource_util.dart';

abstract class MarketOrderDataSource {
  Future<Either<Failure, dynamic>> postMarketOrder({
    @required String baseAsset,
    @required String quoteAsset,
    @required BinanceOrderSide side,
    @required Decimal quantity,
    @required Decimal quoteOrderQty,
  });
}

class MarketOrderDataSourceImpl implements MarketOrderDataSource {
  final Client client;
  final String path = '/api/v3/order';

  MarketOrderDataSourceImpl({@required this.client});

  @override
  Future<Either<Failure, dynamic>> postMarketOrder({
    @required String baseAsset,
    @required String quoteAsset,
    @required BinanceOrderSide side,
    @required Decimal quantity,
    @required Decimal quoteOrderQty,
  }) async {
    String symbol = baseAsset + quoteAsset;
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> params = {
      'timestamp': timeStamp.toString(),
      'symbol': symbol,
      'side': side.toShortString(),
      'type': BinanceOrderType.MARKET.toShortString(),
      ...(quoteOrderQty == null ? {'quantity': quantity.toString()} : {'quoteOrderQty': quoteOrderQty.toString()}),
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
