import 'package:flutter/material.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/order_response_full.dart';
import 'popup_row_division.dart';
import 'popup_row_division_status.dart';

class StopLimitOrderPopupDialog extends StatelessWidget {
  final OrderResponseFull orderResponse;

  StopLimitOrderPopupDialog(this.orderResponse);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RowDivisionStatus(orderResponse.status, orderResponse.side),
        if (orderResponse.side == BinanceOrderSide.BUY) ...[
          RowDivision('STOP PRICE:', orderResponse.stopPrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('LIMIT PRICE:', orderResponse.price.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('TO BUY:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('TO SPENT:', (orderResponse.price * orderResponse.origQty).toString() + ' ' + orderResponse.ticker.quoteAsset),
        ],
        if (orderResponse.side == BinanceOrderSide.SELL) ...[
          RowDivision('STOP PRICE:', orderResponse.stopPrice.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('LIMIT PRICE:', orderResponse.price.toString() + ' ' + orderResponse.ticker.quoteAsset),
          RowDivision('TO SELL:', orderResponse.origQty.toString() + ' ' + orderResponse.ticker.baseAsset),
          RowDivision('TO RECEIVE:', (orderResponse.price * orderResponse.origQty).toString() + ' ' + orderResponse.ticker.quoteAsset),
        ],
      ],
    );
  }
}
