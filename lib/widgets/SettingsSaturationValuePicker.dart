import 'package:flutter/material.dart';
import 'package:noriskclient/widgets/NoRiskContainer.dart';
import 'package:noriskclient/widgets/SettingsSaturationValuePainter.dart';

class SettingsSaturationValuePicker extends StatelessWidget {
  final double hue;
  final double saturation;
  final double value;
  final Function(double saturation, double value) onChanged;

  const SettingsSaturationValuePicker({
    super.key,
    required this.hue,
    required this.saturation,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey colorBoxKey = GlobalKey();

    return GestureDetector(
      onPanUpdate: (details) {
        final box = colorBoxKey.currentContext!.findRenderObject() as RenderBox;
        final localPos = box.globalToLocal(details.globalPosition);
        final width = box.size.width;
        final height = box.size.height;

        final newSaturation = localPos.dx.clamp(0.0, width) / width;
        final newValue = 1 - (localPos.dy.clamp(0.0, height) / height);

        onChanged(newSaturation, newValue);
      },
      child: NoRiskContainer(
        key: colorBoxKey,
        width: double.infinity,
        height: 200,
        child: CustomPaint(
          painter: SettingsSaturationValuePainter(hue, saturation, value),
        ),
      ),
    );
  }
}
