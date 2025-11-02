class Config {
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
    'https://play.google.com/store/apps/details?id=gg.norisk.noriskclient',
  );
  static Uri appStoreUrl = Uri.parse(
    'https://apps.apple.com/de/app/norisk-client/id6661020268',
  );
}
