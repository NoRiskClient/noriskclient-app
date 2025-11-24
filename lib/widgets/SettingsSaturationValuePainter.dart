import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SettingsSaturationValuePainter extends CustomPainter {
  final double hue;
  final double saturation;
  final double value;

  SettingsSaturationValuePainter(this.hue, this.saturation, this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final saturationGradient = ui.Gradient.linear(
      rect.topLeft,
      rect.topRight,
      [Colors.white, HSVColor.fromAHSV(1, hue, 1, 1).toColor()],
    );

    final valueGradient = ui.Gradient.linear(
      rect.topLeft,
      rect.bottomLeft,
      [Colors.transparent, Colors.black],
    );

    final paint = Paint()..shader = saturationGradient;
    canvas.drawRect(rect, paint);

    final valuePaint = Paint()..shader = valueGradient;
    canvas.drawRect(rect, valuePaint);

    final markerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final markerX = saturation * size.width;
    final markerY = (1 - value) * size.height;

    const markerSize = 12.0;
    final markerRect = Rect.fromCenter(
      center: Offset(markerX, markerY),
      width: markerSize,
      height: markerSize,
    );

    canvas.drawRect(markerRect, markerPaint);
  }

  @override
  bool shouldRepaint(covariant SettingsSaturationValuePainter oldDelegate) =>
      oldDelegate.hue != hue ||
      oldDelegate.saturation != saturation ||
      oldDelegate.value != value;
}
