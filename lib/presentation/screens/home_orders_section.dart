import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/presentation/logic/orderconfig_state_notifier.dart';
import 'package:price_action_orders/presentation/widgets/limit_section_widget.dart';
import 'package:price_action_orders/presentation/widgets/market_section_widget.dart';
import 'package:price_action_orders/presentation/widgets/pageselector_widget.dart';
import 'package:price_action_orders/providers.dart';

class OrdersSection extends StatefulWidget {
  @override
  _OrdersSectionState createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

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
    return Consumer(
      builder: (context, watch, child) {
        final orderConfigState = watch(orderConfigNotifierProvider);
        if (orderConfigState is OrderConfigLoaded) {
          return Container(
            child: Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      PageSelector(label: 'Limit', selected: _currentPage == 0, onTapped: () => _onTabTapped(0)),
                      PageSelector(label: 'Market', selected: _currentPage == 1, onTapped: () => _onTabTapped(1)),
                      PageSelector(label: 'Stop-limit', selected: _currentPage == 2, onTapped: () => _onTabTapped(2)),
                    ],
                  ),
                  Divider(height: 1),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      // height: 370,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: [
                          LimitOrderSection(baseAsset: orderConfigState.ticker.baseAsset, quoteAsset: orderConfigState.ticker.quoteAsset),
                          MarketOrderSection(baseAsset: orderConfigState.ticker.baseAsset, quoteAsset: orderConfigState.ticker.quoteAsset),
                          Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
