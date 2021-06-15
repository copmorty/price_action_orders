import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'row_division_status.dart';
import 'row_division.dart';

class LimitOrderPopupDialog extends StatelessWidget {
  final OrderResponseFull orderResponse;

  LimitOrderPopupDialog(this.orderResponse);

  @override
  Widget build(BuildContext context) {
    Decimal weightedAveragePrice;
    if (orderResponse.executedQty > Decimal.zero) {
      final sum = orderResponse.fills.fold(Decimal.zero, (prev, el) => prev + el.price * el.quantity);
      weightedAveragePrice = sum / orderResponse.executedQty;
    }

    return Column(
      children: [
        RowDivisionStatus(orderResponse.status, orderResponse.side),
        if (orderResponse.side == BinanceOrderSide.BUY) ...[
          RowDivision('LIMIT PRICE:', orderResponse.price.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('TO BUY:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('TO SPENT:', (orderResponse.price * orderResponse.origQty).toString() + ' ' + orderResponse.ticker.quoteAsset),
          if (weightedAveragePrice != null) ...[
            Divider(),
            RowDivision('PRICE:', weightedAveragePrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
            RowDivision('BOUGHT:', orderResponse.executedQty.toString() + ' ' + orderResponse.ticker.baseAsset),
            RowDivision('SPENT:', orderResponse.cummulativeQuoteQty.toString() + ' ' + orderResponse.ticker.quoteAsset),
          ],
        ],
        if (orderResponse.side == BinanceOrderSide.SELL) ...[
          RowDivision('LIMIT PRICE:', orderResponse.price.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('TO SELL:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('TO RECEIVE:', (orderResponse.price * orderResponse.origQty).toString() + ' ' + orderResponse.ticker.quoteAsset),
          if (weightedAveragePrice != null) ...[
            Divider(),
            RowDivision('PRICE:', weightedAveragePrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
            RowDivision('SOLD:', orderResponse.executedQty.toString() + ' ' + orderResponse.ticker.baseAsset),
            RowDivision('RECEIVED:', orderResponse.cummulativeQuoteQty.toString() + ' ' + orderResponse.ticker.quoteAsset),
          ],
        ],
      ],
    );
  }
}