import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Tab1 extends StatelessWidget{
  const Tab1({super.key});

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
      print(position);
    } catch (e) {
      print("Error: $e");
    }
  }

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
                  '현재 위치',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B421A),
                  ),
                ),
              ),
              const Positioned(
                bottom: 490,
                left: 96,
                child: Text(
                  'default',
                  style: TextStyle(
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
            ],
          ),
        ),
      ],
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