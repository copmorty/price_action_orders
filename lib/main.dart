import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/presentation/screens/home_screen.dart';
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
      theme: ThemeData.dark(),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider(create: (context) => sl<BookTickerBloc>()),
    //     BlocProvider(create: (context) => sl<OrderBloc>()),
    //     BlocProvider(create: (context) => sl<OrderConfigBloc>()),
    //     BlocProvider(create: (context) => sl<UserDataBloc>()),
    //   ],
    //   child: MaterialApp(
    //     title: 'Price Action Orders',
    //     theme: ThemeData.dark(),
    //     home: HomeScreen(),
    //     debugShowCheckedModeBanner: false,
    //   ),
    // );
  }
}
