import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  Color _blue = const Color(0xFF0066CC);
  Color _background = const Color(0xFF1A1A2E);
  Color _darkerBackground = const Color(0xFF0F0F1E);
  Color _text = Colors.grey;

  Color get blue => _blue;
  Color get background => _background;
  Color get darkerBackground => _darkerBackground;
  Color get text => _text;

  ThemeProvider() {
    _loadSavedColor();
  }

  Future<void> _loadSavedColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedColorHex = prefs.getString('theme_color');

    if (savedColorHex != null) {
      _blue = _hexToColor(savedColorHex);
      notifyListeners();
    }
  }

  Future<void> setBlue(Color color) async {
    _blue = color;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_color', _colorToHex(color));

    notifyListeners();
  }

  String _colorToHex(Color color) {
    return '#${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}';
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
