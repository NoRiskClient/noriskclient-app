import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color _background = const Color.fromARGB(255, 42, 42, 40);
  Color _darkerBackground = Color.fromARGB(255, 32, 31, 31);
  Color _light = const Color.fromARGB(255, 68, 68, 70);
  Color _blue = const Color.fromARGB(255, 52, 147, 235);

  Color _text = const Color.fromARGB(255, 255, 255, 255);
  Color _textLight = const Color.fromARGB(200, 130, 130, 130);

  Color get background => _background;
  Color get darkerBackground => _darkerBackground;
  Color get light => _light;
  Color get blue => _blue;

  Color get text => _text;
  Color get textLight => _textLight;

  void setBackground(Color color) {
    _background = color;
    notifyListeners();
  }

  void setDarkerBackground(Color color) {
    _darkerBackground = color;
    notifyListeners();
  }

  void setLight(Color color) {
    _light = color;
    notifyListeners();
  }

  void setBlue(Color color) {
    _blue = color;
    notifyListeners();
  }

  void setText(Color color) {
    _text = color;
    notifyListeners();
  }

  void setTextLight(Color color) {
    _textLight = color;
    notifyListeners();
  }
}
