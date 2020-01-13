import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountDownPainter extends CustomPainter {

  final Animation<double> animation;
  final Color backgroundColor, color;

  CountDownPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {

    Rect rect = new Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: 360,
    );

    // a fancy rainbow gradient
    final Gradient gradient = new  SweepGradient(
        colors: [Colors.blue, Colors.green, Colors.yellow, Colors.red, Colors.blue],
        stops: [0.0, 0.25, 0.5, 0.75, 1],
      );

    Paint paint = new Paint()
    ..color = Colors.grey[350]
    ..strokeWidth = 7.0
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.fill;

    canvas.drawCircle(size.center(Offset.zero), size.width/2, paint);

    paint.color = backgroundColor;
    paint.style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width/2, paint);

    paint.color = color;

    // center is the center of the canvas
    paint.shader = gradient.createShader(
      rect
    );
    paint.style = PaintingStyle.stroke;

    double progress = (1-animation.value) * 2 * pi;

    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CountDownPainter old) {
    return animation.value != old.animation.value || color != old.color || backgroundColor != old.backgroundColor;
  }
}