import 'package:flutter/material.dart';

import 'Tab1.dart';
import 'Tab2.dart';
import 'Tab3.dart';
import 'Tab4.dart';

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
      home: MyHomePage(title: "Week2"),

    );
  }

  ThemeData _buildThemeData() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0B421A)),
      scaffoldBackgroundColor: Color(0xFF0B421A),
      useMaterial3: true,
    );

    return base.copyWith();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

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
          children: const[
            Tab1(),
            Tab2(),
            Tab3(),
            Tab4(),
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
            label: 'Add',
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
            label: 'List',
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
            label: 'Friends',
            icon: Container(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.groups),
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0xFFF6F3F0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(Icons.groups),
            ),
          ),
          BottomNavigationBarItem(
            label: 'MyProfile',
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

