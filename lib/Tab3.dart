import 'package:flutter/material.dart';

class Tab3 extends StatelessWidget{
  const Tab3({super.key});

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
            '산책메이트',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF6F3F0),
            ),
          ),
        ),
        Positioned(
          bottom: 690,
          left: 170.0,
          child: CustomPaint(
            painter: MyLinePainter(),
            size: const Size(210, 10),
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
    const Offset endPoint = Offset(210, 0);

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}