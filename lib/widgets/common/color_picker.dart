import 'package:flutter/material.dart';

class NoRiskColorPicker extends StatelessWidget {
  const NoRiskColorPicker({
    super.key,
    required this.color,
    required this.hue,
    required this.onColorChanged,
    required this.onHueChanged,
  });

  final Color color;
  final double hue;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<double> onHueChanged;

  void _updateSquare(Offset point, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final dx = point.dx.clamp(0.0, size.width).toDouble();
    final dy = point.dy.clamp(0.0, size.height).toDouble();

    final saturation = dx / size.width;
    final value = 1.0 - (dy / size.height);

    onColorChanged(
      HSVColor.fromAHSV(
        1.0,
        hue,
        saturation,
        value,
      ).toColor(),
    );
  }

  void _updateHue(Offset point, Size size) {
    if (size.width <= 0) return;

    final dx = point.dx.clamp(0.0, size.width).toDouble();

    final newHue = (dx / size.width * 360.0)
        .clamp(0.0, 360.0)
        .toDouble();

    onHueChanged(newHue);
  }

  @override
  Widget build(BuildContext context) {
    final hsv = HSVColor.fromColor(color);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ============================================================
        // COLOR SQUARE
        // ============================================================
        AspectRatio(
          aspectRatio: 1.8,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = width / 1.8;

              final size = Size(width, height);

              final knob = Offset(
                hsv.saturation * width,
                (1.0 - hsv.value) * height,
              );

              return GestureDetector(
                behavior: HitTestBehavior.opaque,

                onPanDown: (details) {
                  _updateSquare(
                    details.localPosition,
                    size,
                  );
                },

                onPanUpdate: (details) {
                  _updateSquare(
                    details.localPosition,
                    size,
                  );
                },

                child: SizedBox(
                  width: width,
                  height: height,
                  child: CustomPaint(
                    painter: _ColorSquarePainter(
                      hue: hue,
                      knob: knob,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // ============================================================
        // HUE SLIDER
        // ============================================================
        SizedBox(
          height: 24,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              final size = Size(width, height);

              final position = (hue / 360.0) * width;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,

                onPanDown: (details) {
                  _updateHue(
                    details.localPosition,
                    size,
                  );
                },

                onPanUpdate: (details) {
                  _updateHue(
                    details.localPosition,
                    size,
                  );
                },

                child: CustomPaint(
                  size: size,
                  painter: _HueSliderPainter(
                    position: position,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// COLOR SQUARE PAINTER
// ============================================================================

class _ColorSquarePainter extends CustomPainter {
  const _ColorSquarePainter({
    required this.hue,
    required this.knob,
  });

  final double hue;
  final Offset knob;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    final rect = Offset.zero & size;

    // ------------------------------------------------------------
    // Base Hue Color
    // ------------------------------------------------------------

    final baseColor = HSVColor.fromAHSV(
      1.0,
      hue.clamp(0.0, 360.0),
      1.0,
      1.0,
    ).toColor();

    canvas.drawRect(
      rect,
      Paint()..color = baseColor,
    );

    // ------------------------------------------------------------
    // Saturation: White -> Transparent
    // ------------------------------------------------------------

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white,
            Colors.transparent,
          ],
        ).createShader(rect),
    );

    // ------------------------------------------------------------
    // Value: Transparent -> Black
    // ------------------------------------------------------------

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black,
          ],
        ).createShader(rect),
    );

    // ------------------------------------------------------------
    // Picker Position
    // ------------------------------------------------------------

    final pickerPosition = Offset(
      knob.dx.clamp(0.0, size.width).toDouble(),
      knob.dy.clamp(0.0, size.height).toDouble(),
    );

    // Outer black border
    canvas.drawCircle(
      pickerPosition,
      9,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Inner white border
    canvas.drawCircle(
      pickerPosition,
      7,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _ColorSquarePainter oldDelegate) {
    return oldDelegate.hue != hue ||
        oldDelegate.knob != knob;
  }
}

// ============================================================================
// HUE SLIDER PAINTER
// ============================================================================

class _HueSliderPainter extends CustomPainter {
  const _HueSliderPainter({
    required this.position,
  });

  final double position;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }

    final rect = Offset.zero & size;

    // ------------------------------------------------------------
    // Hue Gradient
    // ------------------------------------------------------------

    final gradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.red,
        Colors.yellow,
        Colors.green,
        Colors.cyan,
        Colors.blue,
        Colors.purple,
        Colors.red,
      ],
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        const Radius.circular(12),
      ),
      Paint()..shader = gradient.createShader(rect),
    );

    // ------------------------------------------------------------
    // Slider Knob
    // ------------------------------------------------------------

    final x = position
        .clamp(0.0, size.width)
        .toDouble();

    final knobPosition = Offset(
      x,
      size.height / 2,
    );

    // Black outer ring
    canvas.drawCircle(
      knobPosition,
      9,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // White inner ring
    canvas.drawCircle(
      knobPosition,
      7,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _HueSliderPainter oldDelegate) {
    return oldDelegate.position != position;
  }
}