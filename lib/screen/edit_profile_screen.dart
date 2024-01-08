import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Tab4.dart';

class EditProfile extends StatefulWidget{
  final GoogleSignInAccount? user;
  EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 790,
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
            bottom: 790,
            left: 28.0,
            child: Text(
              '프로필 수정',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF6F3F0),
              ),
            ),
          ),
          Positioned(
            bottom: 790,
            left: 200.0,
            child: CustomPaint(
              painter: MyLinePainter(),
              size: const Size(180, 10),
            ),
          ),
          Positioned(
            bottom: 803,
            left: 340.0,
            child: Image.asset(
              'assets/tree.png',
              width: 38,
              height: 38,
            ),
          ),

          Positioned(
            child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: 150,
                    left: 10,
                    right: 10,
                    child: Container(
                      child: Text(
                          '프로필 정보 중 닉네임을 수정할 수 있습니다.',
                          textAlign: TextAlign.center,
                        ),
                    ),
                  ),
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
          Positioned(
            top: 450,
              child: Row(
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
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFFECECEC),
                      ),
                      height: 30,
                      child: Center(
                        child: TextField(
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: '새로운 닉네임을 입력하세요.',
                            ),
                            textAlign: TextAlign.center,
                            onSubmitted: (str) {
                              updateJsonData('${widget.user?.email}', str);
                              Navigator.of(context).pop();
                            }
                        ),
                      ),
                    ),
                  ),
                ],
              ),

          ),
        ],
      ),
    );
  }

  updateJsonData(String email, String nickname) async{
    try {
      // 이메일 주소를 인코딩하여 URI에 추가
      String encodedEmail = Uri.encodeComponent(email);
      Map<String, dynamic> data = {'user_nickname': nickname};
      String jsonString = jsonEncode(data);

      final response = await http.patch(Uri.parse('http://15.164.95.87:5000/update/user_nickname?encodedEmail=$encodedEmail'), headers: {'Content-Type': 'application/json'}, body: jsonString);

      if (response.statusCode == 200) {
        print('Update successful');
        print('Response body: ${response.body}');
      } else {
        print('Failed to update. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error updating nickname: $e');
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
    const Offset endPoint = Offset(180, 0);

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}