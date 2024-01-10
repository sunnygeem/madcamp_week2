import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madcamp_week2/api/google_signin_api.dart';
import 'package:madcamp_week2/main.dart';

class SignupPage extends StatefulWidget{
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 10.0,
          ),
          onPressed: signIn,
          icon: Image.asset(
            'assets/google.png',
            width: 28,
            height: 28,
          ),
          label: Text(
              '  구글 회원가입/로그인 ',
              style: TextStyle(
                color: Colors.black,
              ),
          ),
        ),
      ),
    );
  }

  Future signIn() async
  {
    final user = await GoogleSignInApi.login();
    
    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('회원가입 실패')));
    }else{
      // upload data to DB
      insertDataToAcc(user.email, user.displayName.toString());

      // navigate to main page
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MyHomePage(user: user),
      ));
    }
  }

  insertDataToAcc(String email, String name) async {
    dynamic data = {'user_email': email, 'user_name': name};
    String jsonString = jsonEncode(data);

    try {
      final response = await http.post(Uri.parse('http://10.0.2.2:8000/sendUserInfo'),
          headers: {"Content-Type": "application/json; charset=UTF-8"}, body: jsonString);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    } catch (e) {
      print("Error: $e");
    }
  }

}
