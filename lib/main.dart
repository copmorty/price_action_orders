import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/auth/_screen.dart';
import 'presentation/screens/home/_screen.dart';
import 'presentation/shared/colors.dart';
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
      theme: ThemeData.dark().copyWith(accentColor: mainColor),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (ctx) => AuthScreen(),
        '/home': (ctx) => HomeScreen(),
      },
    );
  }
}
