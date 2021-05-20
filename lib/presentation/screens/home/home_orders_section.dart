import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/widgets/tab_selector.dart';
import 'orders_section/open_orders_wall.dart';

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
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              TabSelector(label: 'Open Orders', selected: _currentPage == 0, onTapped: () => _onTabTapped(0)),
              TabSelector(label: 'Orders History', selected: _currentPage == 1, onTapped: () => _onTabTapped(1)),
              TabSelector(label: 'Trade History', selected: _currentPage == 2, onTapped: () => _onTabTapped(2)),
            ],
          ),
          Divider(height: 1),
          SizedBox(height: 5),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                OpenOrdersWall(),
                Container(),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
