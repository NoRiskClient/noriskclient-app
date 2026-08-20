import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noriskclient/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = localeFromCode(_initialLanguageCode());
  Locale get locale => _locale;

  void setLocale(String languageCode) {
    final normalizedCode = _normalizeLanguageCode(languageCode);
    _locale = localeFromCode(normalizedCode);
    notifyListeners();
  }

  static Locale localeFromCode(String code) {
    final parts = code.replaceAll('_', '-').split('-');
    return parts.length > 1
        ? Locale(parts.first, parts.sublist(1).join('-'))
        : Locale(parts.first);
  }

  static String localeCode(Locale locale) {
    return locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : '${locale.languageCode}-${locale.countryCode}';
  }

  static String _initialLanguageCode() {
    final deviceCode = localeCode(PlatformDispatcher.instance.locale);
    return _findSupportedLanguage(deviceCode) ?? Config.fallbackLangauge;
  }

  static String _normalizeLanguageCode(String languageCode) {
    return _findSupportedLanguage(languageCode) ?? Config.fallbackLangauge;
  }

  static String? _findSupportedLanguage(String languageCode) {
    for (final supportedLanguage in Config.availableLanguages) {
      if (supportedLanguage.toLowerCase() == languageCode.toLowerCase() ||
          supportedLanguage.split('-').first.toLowerCase() ==
              languageCode.toLowerCase()) {
        return supportedLanguage;
      }
    }
    return null;
  }

  Future<void> loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final language = _normalizeLanguageCode(
      prefs.getString('language') ?? _initialLanguageCode(),
    );
    setLocale(language);

    if (prefs.getString('language') == null) {
      await prefs.setString('language', language);
    }
  }
}
