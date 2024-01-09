import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/screen/sing_up_screen.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>{
  int imageIndex = 1;

  @override
  void initState(){
    super.initState();
    startAnimation();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: imageIndex <= 5 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 400),
          child: Image(
            image: AssetImage('assets/logo_mini_$imageIndex.png'),
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }

  Future<void> startAnimation() async {
    int interval = 400;

    for (int i = 1; i <= 5; i++) {
      await Future.delayed(Duration(milliseconds: interval));
      setState(() {
        imageIndex = i;
      });
    }
    await Future.delayed(Duration(milliseconds: 500));
    // 애니메이션이 완료된 후 SignUpPage로 이동합니다.
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupPage()));
  }
}