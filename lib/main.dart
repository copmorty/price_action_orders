import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/injection_container.dart';
import 'package:price_action_orders/presentation/bloc/order_bloc.dart';
import 'package:price_action_orders/presentation/bloc/orderconfig_bloc.dart';
import 'package:price_action_orders/presentation/screens/home_screen.dart';
import 'presentation/bloc/bookticker_bloc.dart';
import 'presentation/bloc/userdata_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<BookTickerBloc>()),
        BlocProvider(create: (context) => sl<OrderBloc>()),
        BlocProvider(create: (context) => sl<OrderConfigBloc>()),
        BlocProvider(create: (context) => sl<UserDataBloc>()),
      ],
      child: MaterialApp(
        title: 'Price Action Orders',
        theme: ThemeData.dark(),
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
