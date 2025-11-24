import 'package:flutter/material.dart';
import 'package:noriskclient/widgets/NoRiskContainer.dart';
import 'package:noriskclient/widgets/SettingsColorSelector.dart';

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
  void didUpdateWidget(SettingsColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedColor != widget.selectedColor) {
      setState(() {
        _selectedColor = widget.selectedColor;
      });
    }
  }

  bool _isPresetColor() {
    return _colors.any((color) => _colorsEqual(color, _selectedColor));
  }

  bool _colorsEqual(Color a, Color b) {
    return a.toARGB32() == b.toARGB32();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ..._colors.map((color) {
          final bool isSelected = _colorsEqual(_selectedColor, color);
          return GestureDetector(
              onTap: () {
                setState(() => _selectedColor = color);
                widget.onColorChange(color);
              },
              child: NoRiskContainer(
                height: 44,
                width: 44,
                color: color,
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 22)
                    : null,
              ));
        }),
        GestureDetector(
            onTap: () async {
              await _openColorWheel();
            },
            child: NoRiskContainer(
              width: 44,
              height: 44,
              color: _selectedColor,
              child: Icon(
                _isPresetColor() ? Icons.edit : Icons.check,
                color: Colors.white,
                size: 22,
              ),
            )),
      ],
    );
  }

  Future<void> _openColorWheel() async {
    await showGeneralDialog(
      context: context,
      barrierLabel: "ColorPicker",
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: SettingsColorSelector(
              initialColor: _selectedColor,
              onColorSelected: (color) {
                setState(() {
                  _selectedColor = color;
                });
                widget.onColorChange(color);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(animation.value),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
