import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:vector_math/vector_math.dart';

class CustomArcPanter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);

    var gradientColor = LinearGradient(
        colors: [TColor.secondary, TColor.secondary50, TColor.secondary0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    Paint activePaint = Paint()..shader = gradientColor.createShader(rect);
    activePaint.style = PaintingStyle.stroke;
    activePaint.strokeWidth = 15;
    activePaint.strokeCap = StrokeCap.round;

    Paint backgroundPaint = Paint()..shader = gradientColor.createShader(rect);
    backgroundPaint.color = TColor.gray30;
    backgroundPaint.style = PaintingStyle.stroke;
    backgroundPaint.strokeWidth = 15;
    backgroundPaint.strokeCap = StrokeCap.round;

    canvas.drawArc(rect, radians(135), radians(270), false, backgroundPaint);
    canvas.drawArc(rect, radians(135), radians(200), false, activePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
