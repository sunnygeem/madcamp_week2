import 'package:flutter/material.dart';

class Tab4 extends StatelessWidget{
  const Tab4({super.key});

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 28),
                        child: const Text(
                          '닉네임',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B421A),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 100),
                        decoration: BoxDecoration(
                          color: Color(0xFFEAC784),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Text(
                          'default',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 28),
                        child: const Text(
                          'e-mail',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B421A),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 100),
                        child: const Text(
                          'default',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 28),
                        child: const Text(
                          '티어',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B421A),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 100),
                        child: const Text(
                          'default',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
    const Offset endPoint = Offset(230, 0);

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}