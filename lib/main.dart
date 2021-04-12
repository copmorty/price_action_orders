import 'package:flutter/material.dart';
import 'package:price_action_orders/injection_container.dart';
import 'package:price_action_orders/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Action Orders',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
