import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'Tab4.dart';

class EditProfile extends StatefulWidget{
  final GoogleSignInAccount? user;
  EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  String input_nickname = '';

  File? _selectedImage;

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
          //
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 200,),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 152,
                        height: 152,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0B421A),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                      _selectedImage != null ? ClipOval(child: Image.file(_selectedImage!, width: 130, height: 130, fit: BoxFit.cover,),) : const Text("이미지를 선택해 주세요."),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 150),
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xfff6f3f0),
                        elevation: 5.0,
                      ),
                      onPressed: (){
                        getImage();

                      },
                      child: Text(
                        '이미지 변경',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          child: const Text(
                            '닉네임',
                            textAlign: TextAlign.start,
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
                                onChanged: (str) {
                                  setState(() {
                                    input_nickname = str;
                                  });
                                }
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100,),
                  Container(
                    padding: EdgeInsets.all(30),
                    child: Divider(),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 100),
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF0B421A),
                        elevation: 5.0,
                      ),
                      onPressed: (){
                        updateJsonData('${widget.user?.email}', input_nickname);
                        uploadImageToDatabase(_selectedImage!, widget.user!.email);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '저장하기',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
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
  
  Future getImage() async{
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  // image converting
  String base64String(Uint8List data) {
    return base64Encode(data);
  }
  Future<Uint8List> fileToUint8List(File file) async {
    return await file.readAsBytes();
  }
  Future<void> uploadImageToDatabase(File imageFile, String email) async {
    try {
      // 이미지 파일을 Uint8List로 변환
      Uint8List imageBytes = await fileToUint8List(imageFile);
      // 이미지를 Base64로 인코딩
      String base64Image = base64String(imageBytes);
      String encodedEmail = Uri.encodeComponent(email);
      Map<String, dynamic> data = {'user_img': base64Image};
      String jsonString = jsonEncode(data);

      final response = await http.patch(Uri.parse('http://15.164.95.87:5000/update/user_img?encodedEmail=$encodedEmail'), headers: {'Content-Type': 'application/json'}, body: jsonString);

      if (response.statusCode == 200) {
        print('Update successful');
        print('Response body: ${response.body}');
      } else {
        print('Failed to update. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error updating Profile Image: $e');
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