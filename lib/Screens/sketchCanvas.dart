import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:sketchingapp/Screens/drawPoint.dart';

class SketchCanvas extends CustomPainter {
  List<DrawPoint> drawPoints;
  SketchCanvas({this.drawPoints});

  @override
  void paint(Canvas canvas, Size size) {
    //For each drawPoint in drawPaints list
    for (int i = 0; i < drawPoints.length; i++) {
      if (i == 0) {
        canvas.drawPoints(
          PointMode.points,
          [drawPoints[i].position],
          drawPoints[i].paint,
        );
      } else if (drawPoints[i - 1] != null && drawPoints[i] != null) {
        canvas.drawLine(
          drawPoints[i - 1].position,
          drawPoints[i].position,
          drawPoints[i].paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  // TODO: implement shouldRepaint

}

class RemoveCanva extends CustomPainter {
  List<DrawPoint> drawPoints;
  RemoveCanva({this.drawPoints});

  @override
  void paint(Canvas canvas, Size size) {
    //For each drawPoint in drawPaints list
    for (int i = 0; i < drawPoints.length; i++) {
      if (i != 0) {
        canvas.drawPoints(
          PointMode.points,
          [drawPoints[i].position],
          drawPoints[i].paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// TODO: implement shouldRepaint

}
