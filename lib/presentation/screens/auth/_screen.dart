import 'package:flutter/material.dart';
import 'auth_access_section.dart';

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
          AccessSection(),
        ],
      ),
    );
  }
}
