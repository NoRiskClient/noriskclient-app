import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;
  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    _locale = locale;
    saveLocale();
    notifyListeners();
  }

  Future<void> saveLocale() async {
    if (_locale == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", _locale!.languageCode);
  }

  Future<void> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString('language');
    if (language == null) return;

    final locale = Locale(language);
    setLocale(locale);
  }
}
