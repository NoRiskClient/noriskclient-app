import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';






class ThemeModeProvider extends ChangeNotifier {
  NoRiskThemeMode _mode = NoRiskThemeMode.dark;
  NoRiskThemeMode get mode => _mode;
  double _borderRadius = 14;
  double get borderRadius => _borderRadius;
  Color? _accentColor;
  Color? get accentColor => _accentColor;
  List<Color> _savedAccentColors = [];
  List<Color> get savedAccentColors => List.unmodifiable(_savedAccentColors);
  Color? _backgroundColor;
  Color? get backgroundColor => _backgroundColor;
  bool get hasCustomBackground => _backgroundColor != null;
  List<Color> _savedBackgroundColors = [];
  List<Color> get savedBackgroundColors =>
      List.unmodifiable(_savedBackgroundColors);

  void setMode(NoRiskThemeMode mode) {
    _mode = mode;
    // Choosing a theme explicitly returns the app to that theme's complete
    // palette instead of mixing it with a manually selected background.
    _backgroundColor = null;
    NoRiskClientColors.setMode(mode);
    NoRiskClientColors.setBackgroundColor(null);
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) => Future.wait([
          prefs.setString(
            'themeMode',
            mode == NoRiskThemeMode.dark ? 'dark' : 'light',
          ),
          prefs.remove('backgroundColor'),
        ]));
  }

  void setBorderRadius(double radius) {
    _borderRadius = radius.clamp(0, 20);
    NoRiskClientColors.setBorderRadius(_borderRadius);
    notifyListeners();
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setDouble('borderRadius', _borderRadius),
    );
  }

  void setAccentColor(Color? color) {
    _accentColor = color;
    NoRiskClientColors.setAccentColor(color);
    if (color != null) {
      _savedAccentColors = [
        color,
        ..._savedAccentColors.where((saved) => saved.value != color.value),
      ].take(7).toList();
    }
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      if (color == null) {
        return prefs.remove('accentColor');
      }
      return Future.wait([
        prefs.setInt('accentColor', color.value),
        prefs.setStringList(
          'savedAccentColors',
          _savedAccentColors
              .map((saved) => saved.value.toString())
              .toList(),
        ),
      ]).then((_) => true);
    });
  }

  void setBackgroundColor(Color? color) {
    _backgroundColor = color;
    NoRiskClientColors.setBackgroundColor(color);
    if (color != null) {
      _savedBackgroundColors = [
        color,
        ..._savedBackgroundColors.where((saved) => saved.value != color.value),
      ].take(7).toList();
    }
    notifyListeners();
    SharedPreferences.getInstance().then((prefs) {
      if (color == null) return prefs.remove('backgroundColor');
      return Future.wait([
        prefs.setInt('backgroundColor', color.value),
        prefs.setStringList(
          'savedBackgroundColors',
          _savedBackgroundColors
              .map((saved) => saved.value.toString())
              .toList(),
        ),
      ]).then((_) => true);
    });
  }

  void loadThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('themeMode');
    final mode = stored == 'light'
        ? NoRiskThemeMode.light
        : NoRiskThemeMode.dark;
    _mode = mode;
    NoRiskClientColors.setMode(mode);
    notifyListeners();

    if (stored == null) {
      await prefs.setString('themeMode', 'dark');
    }
    _borderRadius = prefs.getDouble('borderRadius')?.clamp(0, 20) ?? 14;
    final storedColor = prefs.getInt('accentColor');
    _accentColor = storedColor == null ? null : Color(storedColor);
    _savedAccentColors = (prefs.getStringList('savedAccentColors') ?? [])
        .map((value) => int.tryParse(value))
        .whereType<int>()
        .map(Color.new)
        .take(7)
        .toList();
    final storedBackground = prefs.getInt('backgroundColor');
    _backgroundColor =
        storedBackground == null ? null : Color(storedBackground);
    _savedBackgroundColors =
        (prefs.getStringList('savedBackgroundColors') ?? [])
            .map((value) => int.tryParse(value))
            .whereType<int>()
            .map(Color.new)
            .take(7)
            .toList();
    NoRiskClientColors.setBorderRadius(_borderRadius);
    NoRiskClientColors.setAccentColor(_accentColor);
    NoRiskClientColors.setBackgroundColor(_backgroundColor);
    notifyListeners();
  }
}
