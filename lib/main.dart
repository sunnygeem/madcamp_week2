import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() {
  KakaoSdk.init(nativeAppKey: 'f6e96e5eb182ce45ba336e6b156a718e',);
  runApp(const MyApp());
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
      home: KakaoLoginPage(),
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

class KakaoLoginPage extends StatefulWidget {
  @override
  _KakaoLoginPageState createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  Future<void> _loginButtonPressed() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공');
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => MyHomePage(title: 'week2'),
      ),);
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: _loginButtonPressed,
                child: Text(
                  '카카오 로그인',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
