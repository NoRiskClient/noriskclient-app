import 'package:flutter/material.dart';
import 'package:noriskclient/config/Colors.dart';
import 'package:noriskclient/widgets/NoRiskContainer.dart';
import 'package:noriskclient/widgets/NoRiskText.dart';

class SettingsColorInfo extends StatelessWidget {
  final Color color;

  const SettingsColorInfo({
    super.key,
    required this.color,
  });

  String colorToHex(Color color) =>
      '#${color.red.toRadixString(16).padLeft(2, '0').toUpperCase()}'
      '${color.green.toRadixString(16).padLeft(2, '0').toUpperCase()}'
      '${color.blue.toRadixString(16).padLeft(2, '0').toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildColorValueColumn("HEX", colorToHex(color), 100),
        _buildColorValueColumn("R", color.red.toString(), 70),
        _buildColorValueColumn("G", color.green.toString(), 70),
        _buildColorValueColumn("B", color.blue.toString(), 70),
      ],
    );
  }

  Widget _buildColorValueColumn(String label, String value, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NoRiskText(
          label,
          spaceTop: false,
          spaceBottom: false,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        NoRiskContainer(
          width: width,
          height: 50,
          color: Colors.grey,
          child: Center(
            child: NoRiskText(
              value,
              spaceTop: false,
              spaceBottom: false,
              style: const TextStyle(
                color: NoRiskClientColors.text,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
