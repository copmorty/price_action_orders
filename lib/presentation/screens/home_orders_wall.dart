import 'package:flutter/material.dart';
import 'package:price_action_orders/presentation/widgets/pageselector_widget.dart';

class OrdersWall extends StatefulWidget {
  @override
  _OrdersWallState createState() => _OrdersWallState();
}

class _OrdersWallState extends State<OrdersWall> {
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
    return Column(
      children: [
        Row(
          children: [
            PageSelector(label: 'Open Orders', selected: _currentPage == 0, onTapped: () => _onTabTapped(0)),
            PageSelector(label: 'Orders History', selected: _currentPage == 1, onTapped: () => _onTabTapped(1)),
            PageSelector(label: 'Trade History', selected: _currentPage == 2, onTapped: () => _onTabTapped(2)),
          ],
        ),
        Expanded(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              Container(),
              Container(),
              Container(),
            ],
          ),
        ),
      ],
    );
  }
}
