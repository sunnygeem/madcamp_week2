import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:madcamp_week2/screen/edit_profile_screen.dart';
import 'package:madcamp_week2/screen/sing_up_screen.dart';
import 'package:http/http.dart' as http;

// tab: myprofile
class Tab4 extends StatelessWidget{
  final GoogleSignInAccount? user;
  const Tab4({super.key, required this.user,});

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 690,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              color: Color(0xFFF6F3F0),
            ),
          ),
        ),
        const Positioned(
          bottom: 690,
          left: 28.0,
          child: Text(
            '내 프로필',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF6F3F0),
            ),
          ),
        ),
        Positioned(
          bottom: 690,
          left: 150.0,
          child: CustomPaint(
            painter: MyLinePainter(),
            size: const Size(230, 10),
          ),
        ),
        Positioned(
          bottom: 703,
          left: 340.0,
          child: Image.asset(
            'assets/tree.png',
            width: 38,
            height: 38,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                bottom: 500,
                child: Container(
                  width: 152,
                  height: 152,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0B421A),
                  ),
                ),
              ),
              const Positioned(
                bottom: 511,
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Color(0xFFEAC784),
                  backgroundImage: AssetImage('assets/default_icon.png'),
                ),
              ),
            ],
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 330),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          child: const Text(
                            '닉네임',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B421A),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 240,
                        child: Container(
                          margin: EdgeInsets.only(left: 24),
                          decoration: BoxDecoration(
                            color: Color(0xFFEAC784),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: 30,
                          child: Center(
                            child: FutureBuilder<String?>(
                              future: getStringData('${user?.email}'),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // 로딩 중일 때 표시할 위젯
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  // 반환된 String 데이터를 Text 위젯에 출력
                                  String? jsonString = snapshot.data;
                                  if (jsonString != null) {
                                    return Text(jsonString);
                                  } else {
                                    return Text('No data available');
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          child: const Text(
                            '이름',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B421A),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 240,
                        child: Container(
                          margin: EdgeInsets.only(left: 24),
                          decoration: BoxDecoration(
                            color: Color(0xFFEAC784),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: 30,
                          child: Center(
                            child: Text(
                              '${user?.displayName}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          child: const Text(
                            'e-mail',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B421A),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 240,
                        child: Container(
                          margin: EdgeInsets.only(left: 24),
                          decoration: BoxDecoration(
                            color: Color(0xFFEAC784),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          height: 30,
                          child: Center(
                            child: Text(
                              '${user?.email}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 100),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF0B421A),
                      elevation: 15.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => EditProfile(user: user,),
                      ));
                    },
                    child: const Text(
                      '프로필 수정',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      backgroundColor: Colors.white,
                      elevation: 8.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ));
                    },
                    child: const Text(
                      '로그아웃',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> getJsonData(String email) async{
    try {
      // 이메일 주소를 인코딩하여 URI에 추가
      String encodedEmail = Uri.encodeComponent(email);
      final response = await http.get(Uri.parse('http://15.164.95.87:5000/getRow/user_email?encodedEmail=$encodedEmail'));
      // 응답을 JSON으로 디코딩하여 반환
      var userJson = json.decode(response.body);
      return userJson;
    } catch (e) {
      print('Error getting JSON data: $e');
      // 예외가 발생하면 null 또는 다른 기본값을 반환하거나 에러 처리를 수행할 수 있습니다.
      return null;
    }
  }


  Future<String?> getStringData(String email) async {
    // try {
    //   // getJsonData 함수 호출
    //   dynamic jsonData = await getJsonData(email);
    //
    //   // jsondata를 String으로 변환
    //   String jsonString = json.encode(jsonData);
    //
    //   return jsonString;
    // } catch (e) {
    //   print('Error getting string data: $e');
    //   // 예외가 발생하면 null 또는 다른 기본값을 반환하거나 에러 처리를 수행할 수 있습니다.
    //   return null;
    // }

    try {
      // getJsonData 함수 호출
      dynamic jsonData = await getJsonData(email);

      // jsonData가 Map인 경우에만 처리
      if (jsonData != null && jsonData is Map<String, dynamic>) {
        // 'user_nickname' 키가 존재하는지 확인 후 해당 값을 가져오기
        if (jsonData.containsKey('user_nickname')) {
          String userNickname = jsonData['user_nickname'];
          // userNickname을 JSON 형태의 문자열로 변환하여 반환
          String jsonString = "$userNickname";
          return jsonString;
        } else {
          return null; // 'user_nickname' 키가 존재하지 않는 경우
        }
      } else {
        return null; // jsonData가 Map이 아닌 경우
      }
    } catch (e) {
      print('Error getting string data: $e');
      // 예외가 발생하면 null 또는 다른 기본값을 반환하거나 에러 처리를 수행할 수 있습니다.
      return null;
    }
  }
}


class MyLinePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFF6F3F0)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    const Offset startPoint = Offset(0, 0);
    const Offset endPoint = Offset(230, 0);

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}

