import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/orderconfig_bloc.dart';
import 'package:price_action_orders/presentation/widgets/buyheader_widget.dart';
import 'package:price_action_orders/presentation/widgets/marketbuy_form.dart';
import 'package:price_action_orders/presentation/widgets/marketsell_form.dart';
import 'package:price_action_orders/presentation/widgets/orderbtn_widget.dart';
import 'package:price_action_orders/presentation/widgets/sellheader_widget.dart';

class OrdersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderConfigBloc, OrderConfigState>(builder: (context, state) {
      // print('state');
      // print(state);
      if (state is LoadedOrderConfig) {
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  OrderTypeBtn(orderType: 'Limit'),
                  OrderTypeBtn(orderType: 'Market'),
                  OrderTypeBtn(orderType: 'Stop-limit'),
                ],
              ),
              Divider(),
              SizedBox(height: 10),
              OrderSection(baseAsset: state.baseAsset, quoteAsset: state.quoteAsset),
            ],
          ),
        );
      }
      return SizedBox();
    });
  }
}

class OrderSection extends StatelessWidget {
  final String baseAsset;
  final String quoteAsset;

  const OrderSection({Key key, @required this.baseAsset, @required this.quoteAsset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              BuyHeader(baseAsset: baseAsset, quoteAsset: quoteAsset),
              SizedBox(height: 10),
              MarketBuyForm(asset: quoteAsset),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              SellHeader(baseAsset: baseAsset, quoteAsset: quoteAsset),
              SizedBox(height: 10),
              MarketSellForm(asset: baseAsset),
            ],
          ),
        ),
      ],
    );
  }
}





