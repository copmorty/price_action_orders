import 'package:flutter/material.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Price Action Orders', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: AuthForm(AppMode.TEST),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: AuthForm(AppMode.PRODUCTION),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
