class Config {
  static const String fallbackLangauge = 'en';
  static const List<String> availableLanguages = [
    'de',
    'en',
    'es',
    'fr',
    'pt-BR',
    'pl',
    'ru',
    'tr',
    'it',
    'zh-CN',
    'ja',
    'ko',
  ];

  static int mcRealTimeframe = 15;
  static int maxPostsPerPage = 10;
  static int maxCommentsPerPage = 25;
  static int maxCommentContentLength = 150;
  static int maxReportContentLength = 200;

  static int messagesPerPage = 5;

  static Uri privacyUrl = Uri.parse('https://blog.norisk.gg/privacy-policy/');
  static Uri termsUrl = Uri.parse('https://blog.norisk.gg/en/terms-of-use/');
  static Uri imprintUrl = Uri.parse('https://blog.norisk.gg/impressum/');
  static Uri supportUrl = Uri.parse('mailto:support@norisk.gg');

  static Uri playStoreUrl = Uri.parse(
      'https://play.google.com/store/apps/details?id=gg.norisk.noriskclient');
  static Uri appStoreUrl =
      Uri.parse('https://apps.apple.com/de/app/norisk-client/id6661020268');
  static Uri launcherDownloadUrl = Uri.parse('https://norisk.gg/downloads');

  static const Map<String, String> languageNames = {
    'de': '🇩🇪 Deutsch',
    'en': '🇬🇧 English',
    'es': '🇪🇸 Español',
    'fr': '🇫🇷 Français',
    'pt-BR': '🇧🇷 Português (Brasil)',
    'pl': '🇵🇱 Polski',
    'ru': '🇷🇺 Русский',
    'tr': '🇹🇷 Türkçe',
    'it': '🇮🇹 Italiano',
    'zh-CN': '🇨🇳 简体中文',
    'ja': '🇯🇵 日本語',
    'ko': '🇰🇷 한국어',
  };
}
