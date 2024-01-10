import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:madcamp_week2/screen/Tab1_createMap.dart';

class Tab1 extends StatefulWidget{
  final GoogleSignInAccount?  user;
  const Tab1({super.key, required this.user});
  @override
  _Tab1State createState() => _Tab1State();
}


class _Tab1State extends State<Tab1>{
  String addressResult = 'default';


  @override
  Widget build(BuildContext context){
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
            '나만의 산책로',
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
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Positioned(
                bottom: 494,
                left: 48,
                child: Container(
                  width: 52,
                  height: 52,
                  child: IconButton(
                    icon: Image.asset('assets/pin.png'),
                    onPressed: () {
                      getLocation();
                    },
                  ),
                ),
              ),
              const Positioned(
                bottom: 515,
                left: 96,
                child: Text(
                  '현재 위치를 확인하세요',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B421A),
                  ),
                ),
              ),
              Positioned(
                bottom: 490,
                left: 96,
                child: Text(
                  addressResult,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 480,
                left: 52.0,
                child: CustomPaint(
                  painter: MyLinePainter2(),
                  size: const Size(310, 10),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 440),
                  Center(
                    child: Positioned(
                      child: Container(
                        width: 152,
                        height: 152,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              spreadRadius: 0,
                              blurRadius: 15,
                              offset: Offset(0,0),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Image.asset('assets/logo_circle.png'),
                          onPressed: () async{
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MapScreen(user: widget.user,)),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void getLocation() async {
    // Check if the app has location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // If permission is denied, request it
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle denied permission
        print("Location permission denied");
        return;
      }
    }

    // Now, you have the permission to access the location
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('${position.latitude}, ${position.longitude}');

      String gpsUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyA2UNVzsvPGUMmhXUb56oMyDCC4e40TqXk&language=ko';
      final responseGps = await http.get(Uri.parse(gpsUrl));
      // String jsonData = convert.jsonDecode(responseGps.body);
      String jsonData = responseGps.body;
      print(jsonData);

      Map<String, dynamic> jsonDataMap = convert.jsonDecode(jsonData);

      // "results" 배열에서 첫 번째 요소 가져오기
      Map<String, dynamic> firstResult = jsonDataMap['results'][0];

      // "address_components" 배열 가져오기
      List<dynamic> addressComponents = firstResult['address_components'];

      // administrative_area_level_1과 sublocality_level_1의 short_name 가져오기
      String administrativeArea='default';
      String sublocality='default';

      for (dynamic component in addressComponents) {
        Map<String, dynamic> componentMap = Map<String, dynamic>.from(component);
        List<String> types = List<String>.from(componentMap['types']);

        if (types.contains("administrative_area_level_1")) {
          administrativeArea = component['short_name'];
        }

        if (types.contains("sublocality_level_1")) {
          sublocality = component['short_name'];
        }
      }

      // 결과 출력
      String addressResultText = administrativeArea + " " + sublocality;
      print(addressResultText);

      setState(() {
        addressResult = addressResultText;
      });

    } catch (e) {
      print("Error: $e");
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

class MyLinePainter2 extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF0B421A)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    const Offset startPoint = Offset(0, 0);
    const Offset endPoint = Offset(310, 0);

    canvas.drawLine(startPoint, endPoint, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}