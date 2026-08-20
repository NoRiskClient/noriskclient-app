import 'package:flutter/material.dart';

enum NoRiskThemeMode { dark, light }

class _Palette {
  final Color background;
  final Color darkerBackground;
  final Color surface;
  final Color light;
  final Color blue;
  final Color blueSoft;
  final Color success;
  final Color danger;
  final Color text;
  final Color textLight;

  const _Palette({
    required this.background,
    required this.darkerBackground,
    required this.surface,
    required this.light,
    required this.blue,
    required this.blueSoft,
    required this.success,
    required this.danger,
    required this.text,
    required this.textLight,
  });
}

const _dark = _Palette(
  background: Color.fromARGB(255, 42, 42, 40),
  darkerBackground: Color.fromARGB(255, 32, 31, 31),
  surface: Color.fromARGB(255, 54, 53, 51),
  light: Color.fromARGB(255, 68, 68, 70),
  blue: Color.fromARGB(255, 52, 147, 235),
  blueSoft: Color.fromARGB(255, 96, 178, 245),
  success: Color.fromARGB(255, 101, 199, 138),
  danger: Color.fromARGB(255, 224, 91, 91),
  text: Color.fromARGB(255, 255, 255, 255),
  textLight: Color.fromARGB(200, 158, 158, 160),
);

const _light = _Palette(
  background: Color.fromARGB(255, 245, 245, 243),
  darkerBackground: Color.fromARGB(255, 232, 232, 229),
  surface: Color.fromARGB(255, 255, 255, 255),
  light: Color.fromARGB(255, 214, 214, 217),
  blue: Color.fromARGB(255, 27, 111, 208),
  blueSoft: Color.fromARGB(255, 64, 138, 219),
  success: Color.fromARGB(255, 39, 148, 91),
  danger: Color.fromARGB(255, 197, 58, 58),
  text: Color.fromARGB(255, 26, 26, 28),
  textLight: Color.fromARGB(220, 100, 100, 104),
);

class NoRiskClientColors {
  NoRiskClientColors._();

  static NoRiskThemeMode _mode = NoRiskThemeMode.dark;
  static Color? _accentColor;
  static Color? _backgroundColor;
  static double _borderRadius = 14;
  static NoRiskThemeMode get mode => _mode;
  static double get borderRadius => _borderRadius;

  static void setMode(NoRiskThemeMode mode) {
    _mode = mode;
  }

  static void setBorderRadius(double radius) {
    _borderRadius = radius.clamp(0, 20);
  }

  static void setAccentColor(Color? color) {
    _accentColor = color;
  }

  static void setBackgroundColor(Color? color) {
    _backgroundColor = color;
  }

  static _Palette get _p => _mode == NoRiskThemeMode.dark ? _dark : _light;

  static Color get background => _backgroundColor ?? _p.background;
  static Color get darkerBackground => _p.darkerBackground;
  static Color get surface => Color.lerp(
        background,
        Colors.white,
        _mode == NoRiskThemeMode.dark ? 0.14 : 0.35,
      )!;
  static Color get light => _hasCustomBackground
      ? Color.lerp(background, text, 0.32)!
      : _p.light;
  static Color get blue => _accentColor ?? _p.blue;
  static Color get blueSoft => (_accentColor ?? _p.blue).withAlpha(220);
  static Color get success => _p.success;
  static Color get danger => _p.danger;
  static bool get _hasCustomBackground => _backgroundColor != null;
  static Color get text => _hasCustomBackground
      ? (background.computeLuminance() > 0.5 ? Colors.black : Colors.white)
      : _p.text;
  static Color get textLight => _hasCustomBackground
      ? (background.computeLuminance() > 0.5
          ? Colors.black.withAlpha(180)
          : Colors.white.withAlpha(190))
      : _p.textLight;
}
