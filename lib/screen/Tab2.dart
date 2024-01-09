import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_week2/screen/Tab2_detail.dart';

class Tab2 extends StatefulWidget {
  const Tab2({Key? key}) : super(key: key);
  // const Tab2({super.key, required this.trail});

  @override
  _Tab2 createState() => _Tab2();
}

class _Tab2 extends State<Tab2>{

  Future<dynamic> getJsonData() async{
    try{
      final response = await http.get(Uri.parse('http://15.164.95.87:5000/getTrailTable'));
      var userJson = json.decode(response.body);
      return userJson;
    } catch(e) {
      print('Error getting JSON data 1: $e');
      return null;
    }
  }

  Future<List<String>?> fetchData() async{
    try{
      dynamic jsonData = await getJsonData();
      await Future.delayed(Duration(seconds: 2));

      if (jsonData != null && jsonData is List){
        List<String> trailnames = [];

        for (var row in jsonData){
          if (row is Map<String, dynamic>){
            if (row.containsKey('trail_name')){
              String trailNames = row['trail_name'];
              String email_from_trail = row['user_email'];
              String nickname_from_email = '';

              String encodedEmail = Uri.encodeComponent(email_from_trail);
              final response = await http.get(Uri.parse('http://15.164.95.87:5000/getRow/user_email?encodedEmail=$encodedEmail'));
              var row_from_email = json.decode(response.body);

              dynamic json_row_from_email = await row_from_email;

              if (json_row_from_email != null && json_row_from_email is Map<String, dynamic>) {
                // 'user_nickname' 키가 존재하는지 확인 후 해당 값을 가져오기
                if (json_row_from_email.containsKey('user_nickname')) {
                  String userNickname = json_row_from_email['user_nickname'];
                  // userNickname을 JSON 형태의 문자열로 변환하여 반환
                  nickname_from_email = userNickname;
                }
              }
              trailnames.add(trailNames);
              trailnames.add(nickname_from_email);
            }
          }
        }
        return trailnames;
      } else {
        return null;
      }
    } catch (e){
      print('Error getting string data 2: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Stack(
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
              '산책로 리스트',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF6F3F0),
              ),
            ),
          ),
          Positioned(
            bottom: 690,
            left: 200.0,
            child: CustomPaint(
              painter: MyLinePainter(),
              size: const Size(180, 10),
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
          Center(
            child: Column(
              children: [
                const SizedBox(height: 98),
                FutureBuilder<List<String>?>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError){
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<String> trailnameList = snapshot.data ?? [];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: 650,
                          child: ListView.builder(
                            itemCount: ((trailnameList.length)/2).round(),
                            itemBuilder: (context, index) {
                              return Container(
                                height: 120,
                                child: Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.only(top: 10, right: 5, left: 5, bottom: 5),
                                  color: Color(0xFFF6F3F0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      trailnameList[index*2],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32,
                                        color: Color(0xFF0B421A),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    subtitle: Text(
                                      trailnameList[index*2+1],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Tab2DetailScreen(trailName:
                                            trailnameList[index * 2], trailNickname:
                                            trailnameList[index * 2 + 1],),
                                        ),
                                      );
                                    },

                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );

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