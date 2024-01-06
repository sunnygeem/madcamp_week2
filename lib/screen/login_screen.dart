import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Color(0xFFF6F3F0),
            onPrimary: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: signIn,
          icon: null,
          label: null,
        ),
      ),
    );
  }

  
}