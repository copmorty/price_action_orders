import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/providers.dart';
import 'package:price_action_orders/presentation/logic/orderconfig_state_notifier.dart';
import 'package:price_action_orders/presentation/widgets/tab_selector.dart';
import 'widgets/limit_board.dart';
import 'widgets/market_board.dart';

class TradePanel extends StatefulWidget {
  @override
  _TradePanelState createState() => _TradePanelState();
}

class _TradePanelState extends State<TradePanel> {
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
      _pageController.jumpToPage(index);
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
                      TabSelector(label: 'Limit', selected: _currentPage == 0, onTapped: () => _onTabTapped(0)),
                      TabSelector(label: 'Market', selected: _currentPage == 1, onTapped: () => _onTabTapped(1)),
                      TabSelector(label: 'Stop-limit', selected: _currentPage == 2, onTapped: () => _onTabTapped(2)),
                    ],
                  ),
                  Divider(height: 1),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: [
                          LimitBoard(baseAsset: orderConfigState.ticker.baseAsset, quoteAsset: orderConfigState.ticker.quoteAsset),
                          MarketBoard(baseAsset: orderConfigState.ticker.baseAsset, quoteAsset: orderConfigState.ticker.quoteAsset),
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
