import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'row_division_status.dart';
import 'row_division.dart';

class MarketOrderPopupDialog extends StatelessWidget {
  final OrderResponseFull orderResponse;

  MarketOrderPopupDialog(this.orderResponse);

  @override
  Widget build(BuildContext context) {
    Decimal weightedAveragePrice;
    if (orderResponse.executedQty > Decimal.zero) {
      final Decimal sum = orderResponse.fills.fold(Decimal.zero, (Decimal prev, el) => prev + el.price * el.quantity);
      weightedAveragePrice = sum / orderResponse.executedQty;
    }

    return Column(
      children: [
        RowDivisionStatus(orderResponse.status, orderResponse.side),
        if (weightedAveragePrice != null && orderResponse.side == BinanceOrderSide.BUY) ...[
          orderResponse.origQty != orderResponse.executedQty
              ? RowDivision('TRIED TO BUY:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset)
              : SizedBox(),
          RowDivision('BOUGHT:', orderResponse.executedQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('PRICE:', weightedAveragePrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('SPENT:', orderResponse.cummulativeQuoteQty.toString() + ' ' + orderResponse.ticker.quoteAsset),
        ],
        if (weightedAveragePrice != null && orderResponse.side == BinanceOrderSide.SELL) ...[
          orderResponse.origQty != orderResponse.executedQty
              ? RowDivision('TRIED TO SELL:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset)
              : SizedBox(),
          RowDivision('SOLD:', orderResponse.executedQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('PRICE:', weightedAveragePrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('RECEIVED:', orderResponse.cummulativeQuoteQty.toString() + ' ' + orderResponse.ticker.quoteAsset),
        ],
      ],
    );
  }
}
