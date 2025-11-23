import 'package:flutter/material.dart';
import 'package:noriskclient/widgets/SettingsColorWheel.dart';

class SettingsColorPicker extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChange;

  const SettingsColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorChange,
  });

  @override
  State<SettingsColorPicker> createState() => _SettingsColorPicker();
}

class _SettingsColorPicker extends State<SettingsColorPicker> {
  final List<Color> _colors = const [
    Color(0xFF0066CC),
    Color(0xFF00A3FF),
    Color(0xFF1E88E5),
    Color(0xFF4CAF50),
    Color(0xFFFFC107),
    Color(0xFFD32F2F),
  ];

  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ..._colors.map((color) {
          final bool isSelected = _selectedColor == color;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedColor = color);
              widget.onColorChange(color);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: isSelected
                      ? Colors.black.withOpacity(0.3)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 22)
                  : null,
            ),
          );
        }).toList(),
        GestureDetector(
          onTap: () async {
            await _openColorWheel();
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Colors.black.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(Icons.edit, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Future<void> _openColorWheel() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SettingsColorWheel(
            initialColor: _selectedColor,
            onColorSelected: (color) {
              setState(() => _selectedColor = color);
              widget.onColorChange(color);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
