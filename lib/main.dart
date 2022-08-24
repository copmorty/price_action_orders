import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/presentation/shared/themes/default_theme.dart';
import 'presentation/screens/auth/_screen.dart';
import 'presentation/screens/home/_screen.dart';
import 'providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Action Orders',
      theme: defaultTheme,
      debugShowCheckedModeBanner: false,
      scrollBehavior: _MyCustomScrollBehavior(),
      routes: {
        '/': (ctx) => AuthScreen(),
        '/home': (ctx) => HomeScreen(),
      },
    );
  }
}

class _MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        ...PointerDeviceKind.values,
      };
}
