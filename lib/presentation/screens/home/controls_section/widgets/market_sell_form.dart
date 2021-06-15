import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/domain/entities/ticker.dart';
import 'package:price_action_orders/domain/entities/order_request_market.dart';
import 'package:price_action_orders/presentation/logic/trade_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'default_trade_form_field.dart';

class MarketSellForm extends StatefulWidget {
  final String baseAsset;
  final String quoteAsset;

  const MarketSellForm({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  _MarketSellFormState createState() => _MarketSellFormState();
}

class _MarketSellFormState extends State<MarketSellForm> {
  final TextEditingController _controller = TextEditingController();
  int operationId;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _marketSell() {
    if (_controller.text == '') return;

    final quantityText = _controller.text.replaceAll(',', '.');
    final quantity = Decimal.parse(quantityText);
    final quoteOrderQty = null;
    final marketOrder = MarketOrderRequest(
      ticker: Ticker(baseAsset: widget.baseAsset, quoteAsset: widget.quoteAsset),
      side: BinanceOrderSide.SELL,
      quantity: quantity,
      quoteOrderQty: quoteOrderQty,
    );
    operationId = marketOrder.timestamp;

    _controller.clear();
    FocusScope.of(context).unfocus();
    context.read(tradeNotifierProvider.notifier).postMarketOrder(marketOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: whiteColorOp10,
              border: Border.all(color: transparentColor),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Price',
                    style: TextStyle(fontSize: 16, color: whiteColorOp60),
                  ),
                ),
                Text(
                  'Market',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                Text(
                  widget.quoteAsset,
                  style: TextStyle(fontSize: 16, color: whiteColorOp60),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          DefaultTradeFormField(
            hintText: 'Amount',
            suffixText: widget.baseAsset,
            controller: _controller,
            onFieldSubmitted: (_) => _marketSell(),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: Consumer(
              builder: (context, watch, child) {
                final tradeState = watch(tradeNotifierProvider);

                if (tradeState is TradeLoading && tradeState.operationId == operationId) {
                  return ElevatedButton(
                    onPressed: () {},
                    child: LoadingWidget(height: 20, width: 20, color: whiteColorOp70),
                    style: ElevatedButton.styleFrom(primary: sellColor),
                  );
                }

                return ElevatedButton(
                  onPressed: _marketSell,
                  child: Text(
                    'Sell ${widget.baseAsset}',
                    style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(primary: sellColor),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
