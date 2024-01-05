import 'package:flutter/material.dart';

class Tab1 extends StatelessWidget{
  const Tab1({super.key});

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
          top: 48.0,
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
          top: 80.0,
          left: 200.0,
          child: CustomPaint(
            painter: MyLinePainter(),
            size: const Size(180, 10),
          ),
        ),
        Positioned(
          top: 28.0,
          left: 330.0,
          child: Image.asset(
            'assets/tree.png',
            width: 50,
            height: 50,
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