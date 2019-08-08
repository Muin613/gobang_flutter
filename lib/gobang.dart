import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gobang_flutter/screen.dart';

class ChessBoard extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double eWidth = size.width / 15;
    double eHeight = size.height / 15;
    var paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Color(0x77cdb175);
    canvas.drawRect(Offset.zero & size, paint);

    //画棋盘网格
    paint
      ..style = PaintingStyle.stroke //线
      ..color = Colors.black87
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 15; ++i) {
      double dy = eHeight * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }

    for (int i = 0; i <= 15; ++i) {
      double dx = eWidth * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomPoints extends CustomPainter {
  CustomPoints({
    @required this.points,
  });

  var points = List<Point>();
  var circlePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    double eWidth = size.width / 15;
    double eHeight = size.height / 15;
    circlePaint.color = Colors.black;
    for (int i = 0; i < points.length; i += 2) {
      canvas.drawCircle(
        Offset(points[i].x, points[i].y),
        min(eWidth / 2, eHeight / 2) - 2,
        circlePaint,
      );
    }
    circlePaint.color = Colors.white;
    for (int i = 1; i < points.length; i += 2) {
      canvas.drawCircle(
        Offset(points[i].x, points[i].y),
        min(eWidth / 2, eHeight / 2) - 2,
        circlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Point {
  double x;
  double y;
}

class GesturePointsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GesturePointsState();
  }
}

class GesturePointsState extends State<GesturePointsWidget> {
  var points = List<Point>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        var size = ScreenAdapt.px(40);
        var pointX = details.localPosition.dx;
        var pointY = details.localPosition.dy;
        var tempX = pointX % size;
        var tempX1 = pointX - tempX;
        var tempY = pointY % size;
        var tempY1 = pointY - tempY;
        if (tempX < size / 2) {
          tempX = tempX1;
        } else {
          tempX = tempX1 + size;
        }
        if (tempY < size / 2) {
          tempY = tempY1;
        } else {
          tempY = tempY1 + size;
        }
        var point = Point()
          ..x = tempX
          ..y = tempY;
        for (int i = 0; i < points.length; i++) {
          if (points[i].x == point.x && points[i].y == point.y) {
            return;
          }
        }
        setState(() {
          points.add(point);
        });
        print("$pointX $pointY $tempX $tempY");
      },
      child: CustomPaint(
        size: Size(ScreenAdapt.px(600), ScreenAdapt.px(600)),
        painter: CustomPoints(points: points),
      ),
    );
  }
}
