import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/orderconfig_bloc.dart';
import 'package:price_action_orders/presentation/widgets/limit_section_widget.dart';
import 'package:price_action_orders/presentation/widgets/market_section_widget.dart';
import 'package:price_action_orders/presentation/widgets/orderbtn_widget.dart';

class OrdersSection extends StatefulWidget {
  @override
  _OrdersSectionState createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderConfigBloc, OrderConfigState>(builder: (context, state) {
      if (state is LoadedOrderConfig) {
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  OrderTypeBtn(index: 0, selected: _currentPage == 0, onTapped: () => _onTabTapped(0)),
                  OrderTypeBtn(index: 1, selected: _currentPage == 1, onTapped: () => _onTabTapped(1)),
                  OrderTypeBtn(index: 2, selected: _currentPage == 2, onTapped: () => _onTabTapped(2)),
                ],
              ),
              Divider(height: 1),
              SizedBox(height: 10),
              Container(
                height: 370,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    LimitOrderSection(baseAsset: state.ticker.baseAsset, quoteAsset: state.ticker.quoteAsset),
                    MarketOrderSection(baseAsset: state.ticker.baseAsset, quoteAsset: state.ticker.quoteAsset),
                    Container(),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox();
    });
  }
}
