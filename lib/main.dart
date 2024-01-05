import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

void main() {
  runApp(const MyApp());
}

Future<void> dbConnector() async {
  print("Connecting to mysql server...");

  // MySQL 접속 설정
  final conn = await MySQLConnection.createConnection(
    host: 'root',
    port: 3306,
    userName: 'gangtae',
    password: '1234',
    databaseName: 'testdb', // optional
  );

  // 연결 대기
  await conn.connect();

  print("Connected");

  // 종료 대기
  await conn.close();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Week2'),
    );
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: IndexedStack(
          index: _currentIndex,
          children: const[
            Text('tab1'),
            Text('tab2'),
            Text('tab3'),
            Text('tab4'),
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
        items: const[
          BottomNavigationBarItem(
              label: 'Walk',
              icon: Icon(Icons.directions_walk),
          ),
          BottomNavigationBarItem(
            label: 'View',
            icon: Icon(Icons.remove_red_eye),
          ),
          BottomNavigationBarItem(
            label: 'Mate',
            icon: Icon(Icons.people_alt),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
