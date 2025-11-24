import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SettingsHueSliderPainter extends CustomPainter {
  final double hue;

  SettingsHueSliderPainter(this.hue);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final hueGradient = ui.Gradient.linear(
      rect.topLeft,
      rect.topRight,
      [
        HSVColor.fromAHSV(1, 0, 1, 1).toColor(),
        HSVColor.fromAHSV(1, 60, 1, 1).toColor(),
        HSVColor.fromAHSV(1, 120, 1, 1).toColor(),
        HSVColor.fromAHSV(1, 180, 1, 1).toColor(),
        HSVColor.fromAHSV(1, 240, 1, 1).toColor(),
        HSVColor.fromAHSV(1, 300, 1, 1).toColor(),
        HSVColor.fromAHSV(1, 360, 1, 1).toColor(),
      ],
      [0.0, 0.17, 0.33, 0.5, 0.67, 0.83, 1.0],
    );

    final paint = Paint()..shader = hueGradient;
    canvas.drawRect(rect, paint);

    final markerX = (hue / 360) * size.width;
    const markerWidth = 8.0;

    final markerRect = Rect.fromLTWH(
      markerX - markerWidth / 2,
      0,
      markerWidth,
      size.height,
    );

    final markerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawRect(markerRect, markerPaint);
  }

  @override
  bool shouldRepaint(covariant SettingsHueSliderPainter oldDelegate) =>
      oldDelegate.hue != hue;
}
