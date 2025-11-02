// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get localeDisplay => 'Deutsch';

  @override
  String get navbarYou => 'Du';

  @override
  String get signInEula =>
      'Durch die Anmeldung erklärst du dich mit den Nutzungsbedingungen und Datenschutzrichtlinien einverstanden.';

  @override
  String get signInExplanation =>
      'Zum Anmelden scannst du den QR-Code aus dem NoRiskClient-Launcher unter der Menüoption \'Social Accounts\' neben dem Account-Manager.';

  @override
  String get signInScanQrCode => 'QR-Code scannen';

  @override
  String get signInLabel => 'Anmelden';

  @override
  String get signInSigningIn => 'Wird angemeldet...';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsBlockedPlayers => 'Blockierte Spieler';

  @override
  String get settingsLegal => 'Rechtliches';

  @override
  String get settingsTos => 'Nutzungsbedingungen';

  @override
  String get settingsPrivacyPolicy => 'Datenschutz';

  @override
  String get settingsImprint => 'Impressum';

  @override
  String get settingsSupport => 'Support';

  @override
  String get profileYourProfile => 'Dein Profil';

  @override
  String get profileUsersProfile => '\'s Profil';

  @override
  String get profileStatsFirstJoin => 'Erster Beitritt';

  @override
  String get profileStatsLastJoin => 'Letzter Beitritt';

  @override
  String get profileStatsLoginStreak => 'Login-Serie';

  @override
  String get profileStatsMcReal => 'McReal-Serie';

  @override
  String get profileStatsPlaytime => 'Spielzeit';

  @override
  String get profileNoPinnedPosts => ' hat keine angepinnten Posts :/';

  @override
  String get mcRealFriendsTabLabel => 'Freunde';

  @override
  String get mcRealDiscoverTabLabel => 'Entdecken';

  @override
  String get mcRealPartnersTabLabel => 'Partner';

  @override
  String get mcRealYourMcReal => 'Dein McReal';

  @override
  String get mcRealJustNow => 'Jetzt';

  @override
  String mcRealAgo(String time) {
    return 'Vor $time';
  }

  @override
  String get mcRealCommentLabel => 'Kommentieren';

  @override
  String get mcRealCommentHint => 'Neuer Kommentar';

  @override
  String get mcRealNoComments => 'Keine Kommentare verfügbar.';

  @override
  String get mcRealReply => 'Antworten';

  @override
  String get mcRealCommentReply => 'Antwort';

  @override
  String get mcRealCommentReplies => 'Antworten';

  @override
  String get mcRealCommentYou => 'Du';

  @override
  String get mcRealNoPosts =>
      'Heute hat noch niemand ein McReal gepostet.\nStarte den NoRiskClient, um der Erste zu sein!';

  @override
  String get mcRealNoPostsPlain => 'Keine Posts verfügbar :(';

  @override
  String get mcRealDeleteCommentTitle => 'Bist du sicher?';

  @override
  String get mcRealDeleteCommentContent =>
      'Bist du sicher, dass du diesen Kommentar löschen willst?';

  @override
  String get mcRealDeletePostTitle => 'Bist du sicher?';

  @override
  String get mcRealDeletePostContent =>
      'Bist du dir sicher, dass du dein heutiges McReal löschen willst?\nDu wirst heute kein weiteres McReal posten können!';

  @override
  String get mcRealPinPostTitle => 'Bist du sicher?';

  @override
  String get mcRealPinPostContent =>
      'Bist du dir sicher, dass du dein heutiges McReal anpinnen möchtest?';

  @override
  String get mcRealUnpinPostTitle => 'Bist du sicher?';

  @override
  String get mcRealUnpinPostContent =>
      'Bist du dir sicher, dass du dieses McReal nicht mehr anpinnen möchtest?';

  @override
  String get mcRealPopupCancel => 'Abbrechen';

  @override
  String get mcRealPopupDelete => 'Löschen';

  @override
  String get mcRealPopupOk => 'OK';

  @override
  String get mcRealPopupYes => 'Ja';

  @override
  String get mcRealPopupPin => 'Anpinnen';

  @override
  String get mcRealPopupUnpin => 'Loslösen';

  @override
  String get mcRealRemovedPostInfo =>
      'Dein McReal wurde entfernt.\nTippe hier für mehr Infos.';

  @override
  String get mcRealRemovedPostTitle => 'Dein McReal wurde entfernt';

  @override
  String get mcRealRemovedPostReason => 'Grund';

  @override
  String get mcRealStatusDeleted => 'Du hast deinen Post gelöscht.';

  @override
  String get mcRealStatusNoPost => 'Du hast heute noch kein McReal gepostet.';

  @override
  String get mcRealStatusRemoved => 'Dein McReal wurde entfernt.';

  @override
  String get mcRealProfileNotPosted =>
      'Du musst erst ein McReal posten, bevor du die der anderen sehen kannst.';

  @override
  String get mcRealReportLabel => 'Melden';

  @override
  String get mcRealReportCommentTitle => 'Kommentar melden';

  @override
  String get mcRealReportPostTitle => 'Post melden';

  @override
  String get mcRealReportWhatHappened => 'Was ist passiert?';

  @override
  String get mcRealReportInfoHint => 'Zusätzliche Informationen';

  @override
  String get mcRealReportReasonCopyrightInfringement =>
      'Urheberrechtsverletzung';

  @override
  String get mcRealReportReasonHateSpeech => 'Hassrede';

  @override
  String get mcRealReportReasonInappropriateForMinors =>
      'Für Minderjährige ungeeignet';

  @override
  String get mcRealReportReasonObscenity => 'Obszönität';

  @override
  String get mcRealReportReasonOther => 'Andere';

  @override
  String get mcRealReportReasonPrivacyViolation =>
      'Verletzung der Privatsphäre';

  @override
  String get mcRealReportReasonSpamOrFraud => 'Spam oder Betrug';

  @override
  String get postDetailsTitle => 'Postdetails';

  @override
  String get postDetailsYourMcReal => 'Dein McReal';

  @override
  String get chatDeleteMessageTitle => 'Nachricht löschen';

  @override
  String get chatDeleteMessageContent =>
      'Bist du sicher, dass du diese Nachricht löschen willst?';

  @override
  String get chatMessageDeleted => 'Diese Nachricht wurde gelöscht.';

  @override
  String get chatEmpty => 'Leerer Chat';

  @override
  String get gamescomNoInfo => 'Derzeit sind keine Informationen verfügbar.';

  @override
  String get mcRealBlockUserTitle => 'Bist du sicher?';

  @override
  String get mcRealBlockUserContent => 'Möchtest du diesen Spieler blockieren?';

  @override
  String get mcRealUnblockUserTitle => 'Bist du sicher?';

  @override
  String get mcRealUnblockUserContent =>
      'Möchtest du diesen Spieler wirklich entsperren?';

  @override
  String get mcRealBlockedPlayer => 'Du hast diesen Spieler blockiert.';

  @override
  String get mcRealBlockedNone => 'Du hast keine Spieler blockiert.';
}
