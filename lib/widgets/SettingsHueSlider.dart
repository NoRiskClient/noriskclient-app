import 'package:flutter/material.dart';
import 'package:noriskclient/widgets/SettingsHueSliderPainter.dart';

class SettingsHueSlider extends StatelessWidget {
  final double hue;
  final ValueChanged<double> onChanged;

  const SettingsHueSlider({
    super.key,
    required this.hue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey hueSliderKey = GlobalKey();

    void updateHue(Offset globalPosition) {
      final box = hueSliderKey.currentContext!.findRenderObject() as RenderBox;
      final localPos = box.globalToLocal(globalPosition);
      final width = box.size.width;

      final newHue = (localPos.dx.clamp(0.0, width) / width) * 360;
      onChanged(newHue);
    }

    return GestureDetector(
      onPanUpdate: (details) => updateHue(details.globalPosition),
      onPanDown: (details) => updateHue(details.globalPosition),
      child: Container(
        key: hueSliderKey,
        width: double.infinity,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(0),
        ),
        child: CustomPaint(
          painter: SettingsHueSliderPainter(hue),
        ),
      ),
    );
  }
}
