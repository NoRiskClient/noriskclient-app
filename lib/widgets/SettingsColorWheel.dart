import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SettingsColorWheel extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const SettingsColorWheel({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<SettingsColorWheel> createState() => _SettingsColorWheelState();
}

class _SettingsColorWheelState extends State<SettingsColorWheel> {
  double hue = 0;
  double saturation = 1;
  double value = 1;

  late TextEditingController hexController;
  late TextEditingController rController;
  late TextEditingController gController;
  late TextEditingController bController;

  final GlobalKey _colorBoxKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final hsv = HSVColor.fromColor(widget.initialColor);
    hue = hsv.hue;
    saturation = hsv.saturation;
    value = hsv.value;

    hexController =
        TextEditingController(text: colorToHex(widget.initialColor));
    rController =
        TextEditingController(text: widget.initialColor.red.toString());
    gController =
        TextEditingController(text: widget.initialColor.green.toString());
    bController =
        TextEditingController(text: widget.initialColor.blue.toString());
  }

  Color get currentColor =>
      HSVColor.fromAHSV(1, hue, saturation, value).toColor();

  String colorToHex(Color color) =>
      '#${color.red.toRadixString(16).padLeft(2, '0').toUpperCase()}'
      '${color.green.toRadixString(16).padLeft(2, '0').toUpperCase()}'
      '${color.blue.toRadixString(16).padLeft(2, '0').toUpperCase()}';

  void updateFromRGB() {
    final r = int.tryParse(rController.text) ?? 0;
    final g = int.tryParse(gController.text) ?? 0;
    final b = int.tryParse(bController.text) ?? 0;
    final color = Color.fromARGB(255, r, g, b);
    final hsv = HSVColor.fromColor(color);
    setState(() {
      hue = hsv.hue;
      saturation = hsv.saturation;
      value = hsv.value;
      hexController.text = colorToHex(color);
    });
  }

  void updateFromHex() {
    final text = hexController.text.replaceAll('#', '');
    if (text.length == 6) {
      final color = Color(int.parse('FF$text', radix: 16));
      final hsv = HSVColor.fromColor(color);
      setState(() {
        hue = hsv.hue;
        saturation = hsv.saturation;
        value = hsv.value;
        rController.text = color.red.toString();
        gController.text = color.green.toString();
        bController.text = color.blue.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = currentColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text('COLOR PICKER',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GestureDetector(
            onPanUpdate: (details) {
              final box =
                  _colorBoxKey.currentContext!.findRenderObject() as RenderBox;
              final localPos = box.globalToLocal(details.globalPosition);
              final width = box.size.width;
              final height = box.size.height;

              setState(() {
                saturation = localPos.dx.clamp(0.0, width) / width;
                value = 1 - (localPos.dy.clamp(0.0, height) / height);
                hexController.text = colorToHex(currentColor);
                rController.text = selectedColor.red.toString();
                gController.text = selectedColor.green.toString();
                bController.text = selectedColor.blue.toString();
              });
            },
            child: Container(
              key: _colorBoxKey,
              width: double.infinity,
              height: 200,
              child: CustomPaint(
                painter: SaturationValuePainter(hue, saturation, value),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 20,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 12),
                  ),
                  child: Slider(
                    value: hue,
                    min: 0,
                    max: 360,
                    activeColor: HSVColor.fromAHSV(1, hue, 1, 1).toColor(),
                    onChanged: (v) {
                      setState(() {
                        hue = v;
                        hexController.text = colorToHex(currentColor);
                        rController.text = selectedColor.red.toString();
                        gController.text = selectedColor.green.toString();
                        bController.text = selectedColor.blue.toString();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Flexible(
                child: TextField(
                  controller: hexController,
                  decoration: const InputDecoration(
                      labelText: 'Hex', filled: true, fillColor: Colors.white),
                  onChanged: (_) => updateFromHex(),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextField(
                    controller: rController,
                    decoration: const InputDecoration(
                        labelText: 'R', filled: true, fillColor: Colors.white),
                    onChanged: (_) => updateFromRGB()),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextField(
                    controller: gController,
                    decoration: const InputDecoration(
                        labelText: 'G', filled: true, fillColor: Colors.white),
                    onChanged: (_) => updateFromRGB()),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: TextField(
                    controller: bController,
                    decoration: const InputDecoration(
                        labelText: 'B', filled: true, fillColor: Colors.white),
                    onChanged: (_) => updateFromRGB()),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                color: selectedColor,
              ),
              const Spacer(),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCEL')),
              ElevatedButton(
                onPressed: () {
                  widget.onColorSelected(selectedColor);
                },
                child: const Text('APPLY'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SaturationValuePainter extends CustomPainter {
  final double hue;
  final double saturation;
  final double value;

  SaturationValuePainter(this.hue, this.saturation, this.value);

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
        height: markerSize);

    canvas.drawRect(markerRect, markerPaint);
  }

  @override
  bool shouldRepaint(covariant SaturationValuePainter oldDelegate) =>
      oldDelegate.hue != hue ||
      oldDelegate.saturation != saturation ||
      oldDelegate.value != value;
}
