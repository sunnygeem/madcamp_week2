import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:madcamp_week2/screen/Tab1.dart';
import 'package:madcamp_week2/screen/Tab2.dart';
import 'package:madcamp_week2/screen/Tab4.dart';
import 'package:madcamp_week2/screen/sing_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: _buildThemeData(),
      // home: SignupPage(),
      home: SplashScreen(),
    );
  }

  ThemeData _buildThemeData() {
    final base = ThemeData(
      scaffoldBackgroundColor: Color(0xFF0B421A),
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0B421A)),
      useMaterial3: true,
      primarySwatch: Colors.green,
    );
    return base.copyWith();
  }
}

class MyHomePage extends StatefulWidget {
  final GoogleSignInAccount? user;
  MyHomePage({super.key, required this.user});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(),
        preferredSize: Size.fromHeight(0),
      ),
      body: Center(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            Tab1(user: widget.user,),
            Tab2(),
            Tab4(user: widget.user,),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState((){
            _currentIndex = value;
          });
        },

        selectedItemColor: Color(0xFFF6F3F0),
        unselectedItemColor: Color(0xFFF6F3F0),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(color: Color(0xFF0B421A)),
        unselectedIconTheme: IconThemeData(color: Color(0xFFF6F3F0)),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF0B421A),

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: '산책로 등록',
            icon: Container(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.add),
            ),
          ),
          BottomNavigationBarItem(
            label: '산책로 공유',
            icon: Container(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.list),
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.list),
            ),
          ),
          BottomNavigationBarItem(
            label: '프로필',
            icon: Container(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.account_circle),
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.account_circle),
            ),
          ),
        ],
      ),
    );
  }
}
