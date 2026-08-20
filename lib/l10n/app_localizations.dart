import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
    Locale('zh', 'CN')
  ];

  /// No description provided for @mcRealComment_reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get mcRealComment_reply;

  /// No description provided for @mcRealComment_replys.
  ///
  /// In en, this message translates to:
  /// **'Rreplys'**
  String get mcRealComment_replys;

  /// No description provided for @mcRealComment_you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get mcRealComment_you;

  /// No description provided for @mcRealProfile_notPosted.
  ///
  /// In en, this message translates to:
  /// **'You have to post a McReal before you can see others.'**
  String get mcRealProfile_notPosted;

  /// No description provided for @mcRealReport_info_hint.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get mcRealReport_info_hint;

  /// No description provided for @mcRealReport_reason_copyrightInfringement.
  ///
  /// In en, this message translates to:
  /// **'Copyright Infringement'**
  String get mcRealReport_reason_copyrightInfringement;

  /// No description provided for @mcRealReport_reason_hateSpeach.
  ///
  /// In en, this message translates to:
  /// **'Hate Speach'**
  String get mcRealReport_reason_hateSpeach;

  /// No description provided for @mcRealReport_reason_inappropriateForMinors.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate For Minors'**
  String get mcRealReport_reason_inappropriateForMinors;

  /// No description provided for @mcRealReport_reason_obscenity.
  ///
  /// In en, this message translates to:
  /// **'Obscenity'**
  String get mcRealReport_reason_obscenity;

  /// No description provided for @mcRealReport_reason_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get mcRealReport_reason_other;

  /// No description provided for @mcRealReport_reason_privacyViolation.
  ///
  /// In en, this message translates to:
  /// **'Privacy Violation'**
  String get mcRealReport_reason_privacyViolation;

  /// No description provided for @mcRealReport_reason_spamOrFraud.
  ///
  /// In en, this message translates to:
  /// **'Spam or Fraud'**
  String get mcRealReport_reason_spamOrFraud;

  /// No description provided for @mcRealReport_report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get mcRealReport_report;

  /// No description provided for @mcRealReport_title_comment.
  ///
  /// In en, this message translates to:
  /// **'Report Comment'**
  String get mcRealReport_title_comment;

  /// No description provided for @mcRealReport_title_post.
  ///
  /// In en, this message translates to:
  /// **'Report Post'**
  String get mcRealReport_title_post;

  /// No description provided for @mcRealReport_whatHappened.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get mcRealReport_whatHappened;

  /// No description provided for @mcReal_ago.
  ///
  /// In en, this message translates to:
  /// **'late'**
  String get mcReal_ago;

  /// No description provided for @mcReal_comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get mcReal_comment;

  /// No description provided for @mcReal_comment_hint.
  ///
  /// In en, this message translates to:
  /// **'New Comment'**
  String get mcReal_comment_hint;

  /// No description provided for @mcReal_deleteCommentPopupContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment?'**
  String get mcReal_deleteCommentPopupContent;

  /// No description provided for @mcReal_deleteCommentPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcReal_deleteCommentPopupTitle;

  /// No description provided for @mcReal_deletePostPopupContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete today\'s McReal?\nYou will not be able to post another McReal today!'**
  String get mcReal_deletePostPopupContent;

  /// No description provided for @mcReal_deletePostPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcReal_deletePostPopupTitle;

  /// No description provided for @mcReal_discovery.
  ///
  /// In en, this message translates to:
  /// **'Discovery'**
  String get mcReal_discovery;

  /// No description provided for @mcReal_friendsOnly.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get mcReal_friendsOnly;

  /// No description provided for @mcReal_partnerPosts.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get mcReal_partnerPosts;

  /// No description provided for @mcReal_justNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get mcReal_justNow;

  /// No description provided for @mcReal_noComments.
  ///
  /// In en, this message translates to:
  /// **'No Comments available.'**
  String get mcReal_noComments;

  /// No description provided for @mcReal_noPosts.
  ///
  /// In en, this message translates to:
  /// **'Nobody has posted their McReal yet.\nStart NoRiskClient to be the first one to post!'**
  String get mcReal_noPosts;

  /// No description provided for @mcReal_noPostsPlain.
  ///
  /// In en, this message translates to:
  /// **'No posts available :('**
  String get mcReal_noPostsPlain;

  /// No description provided for @mcReal_pinPostPopupContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to pin todays McReal?'**
  String get mcReal_pinPostPopupContent;

  /// No description provided for @mcReal_pinPostPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcReal_pinPostPopupTitle;

  /// No description provided for @mcReal_popup_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get mcReal_popup_cancel;

  /// No description provided for @mcReal_popup_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete!'**
  String get mcReal_popup_delete;

  /// No description provided for @mcReal_popup_ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get mcReal_popup_ok;

  /// No description provided for @mcReal_popup_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get mcReal_popup_yes;

  /// No description provided for @mcReal_popup_pin.
  ///
  /// In en, this message translates to:
  /// **'Pin!'**
  String get mcReal_popup_pin;

  /// No description provided for @mcReal_popup_unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get mcReal_popup_unpin;

  /// No description provided for @mcReal_removedPost.
  ///
  /// In en, this message translates to:
  /// **'Your McReal was removed.\nTap here for more information.'**
  String get mcReal_removedPost;

  /// No description provided for @mcReal_removedPostPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Your McReal was removed'**
  String get mcReal_removedPostPopupTitle;

  /// No description provided for @mcReal_removedPostReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get mcReal_removedPostReason;

  /// No description provided for @mcReal_reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get mcReal_reply;

  /// No description provided for @mcReal_status_deleted.
  ///
  /// In en, this message translates to:
  /// **'You have deleted your post.'**
  String get mcReal_status_deleted;

  /// No description provided for @mcReal_status_noPost.
  ///
  /// In en, this message translates to:
  /// **'You have not yet posted your McReal of today.'**
  String get mcReal_status_noPost;

  /// No description provided for @mcReal_status_removed.
  ///
  /// In en, this message translates to:
  /// **'Your McReal was removed.'**
  String get mcReal_status_removed;

  /// No description provided for @mcReal_unpinPostPopupContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you no longer want to pin this McReal?'**
  String get mcReal_unpinPostPopupContent;

  /// No description provided for @mcReal_unpinPostPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcReal_unpinPostPopupTitle;

  /// No description provided for @mcReal_yourMcReal.
  ///
  /// In en, this message translates to:
  /// **'Your McReal'**
  String get mcReal_yourMcReal;

  /// No description provided for @postDetails_title.
  ///
  /// In en, this message translates to:
  /// **'Post Details'**
  String get postDetails_title;

  /// No description provided for @postDetails_yourMcReal.
  ///
  /// In en, this message translates to:
  /// **'Your McReal'**
  String get postDetails_yourMcReal;

  /// No description provided for @settings_signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settings_signOut;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @signIn_eula.
  ///
  /// In en, this message translates to:
  /// **'By signing in you agree to the terms of service and privacy policy.'**
  String get signIn_eula;

  /// No description provided for @signIn_explanation.
  ///
  /// In en, this message translates to:
  /// **'To sign in just scan the QR-Code from the NoRiskClient Launcher under the menu option \"Social Accounts\" next to the account manager.'**
  String get signIn_explanation;

  /// No description provided for @signIn_scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get signIn_scanQrCode;

  /// No description provided for @signIn_signIn.
  ///
  /// In en, this message translates to:
  /// **'SignIn'**
  String get signIn_signIn;

  /// No description provided for @signIn_signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get signIn_signingIn;

  /// No description provided for @profile_yourProfile.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get profile_yourProfile;

  /// No description provided for @profile_usersProfile.
  ///
  /// In en, this message translates to:
  /// **'\'s Profile'**
  String get profile_usersProfile;

  /// No description provided for @profile_stats_firstJoin.
  ///
  /// In en, this message translates to:
  /// **'First Join'**
  String get profile_stats_firstJoin;

  /// No description provided for @profile_stats_lastJoin.
  ///
  /// In en, this message translates to:
  /// **'Last Join'**
  String get profile_stats_lastJoin;

  /// No description provided for @profile_stats_loginStreak.
  ///
  /// In en, this message translates to:
  /// **'Login Streak'**
  String get profile_stats_loginStreak;

  /// No description provided for @profile_stats_mcReal.
  ///
  /// In en, this message translates to:
  /// **'McReal Streak'**
  String get profile_stats_mcReal;

  /// No description provided for @profile_stats_playtime.
  ///
  /// In en, this message translates to:
  /// **'Playtime'**
  String get profile_stats_playtime;

  /// No description provided for @profile_noPinnedPosts.
  ///
  /// In en, this message translates to:
  /// **' doesn\'t have any pinned posts :/'**
  String get profile_noPinnedPosts;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_blockedPlayers.
  ///
  /// In en, this message translates to:
  /// **'Blocked Players'**
  String get settings_blockedPlayers;

  /// No description provided for @settings_legal.
  ///
  /// In en, this message translates to:
  /// **'Legal Info\'s'**
  String get settings_legal;

  /// No description provided for @settings_tos.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settings_tos;

  /// No description provided for @settings_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settings_privacyPolicy;

  /// No description provided for @settings_imprint.
  ///
  /// In en, this message translates to:
  /// **'Imprint'**
  String get settings_imprint;

  /// No description provided for @settings_support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settings_support;

  /// No description provided for @mcReal_profile_blockUserPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcReal_profile_blockUserPopupTitle;

  /// No description provided for @mcReal_profile_blockUserPopupContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block this player?'**
  String get mcReal_profile_blockUserPopupContent;

  /// No description provided for @mcReal_profile_unblockUserPopupTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcReal_profile_unblockUserPopupTitle;

  /// No description provided for @mcReal_profile_unblockUserPopupContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unblock this player?'**
  String get mcReal_profile_unblockUserPopupContent;

  /// No description provided for @mcReal_profile_blockedPlayer.
  ///
  /// In en, this message translates to:
  /// **'You have blocked this player.'**
  String get mcReal_profile_blockedPlayer;

  /// No description provided for @mcReal_blocked_noBlockedPlayers.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any blocked players.'**
  String get mcReal_blocked_noBlockedPlayers;

  /// No description provided for @chat_delete_message_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get chat_delete_message_title;

  /// No description provided for @chat_delete_message_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get chat_delete_message_content;

  /// No description provided for @chat_delete_message_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get chat_delete_message_cancel;

  /// No description provided for @chat_delete_message_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get chat_delete_message_delete;

  /// No description provided for @chat_message_deleted.
  ///
  /// In en, this message translates to:
  /// **'This message was deleted.'**
  String get chat_message_deleted;

  /// No description provided for @chat_chat_empty.
  ///
  /// In en, this message translates to:
  /// **'Empty Chat'**
  String get chat_chat_empty;

  /// No description provided for @chats_noChats.
  ///
  /// In en, this message translates to:
  /// **'No Chats Yet'**
  String get chats_noChats;

  /// No description provided for @chats_noChats_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start chatting with your friends!'**
  String get chats_noChats_subtitle;

  /// No description provided for @navbar_you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get navbar_you;

  /// No description provided for @gamescom_no_infos.
  ///
  /// In en, this message translates to:
  /// **'There are no infos available at the moment.'**
  String get gamescom_no_infos;

  /// No description provided for @qrGuide_title.
  ///
  /// In en, this message translates to:
  /// **'How to get your QR code'**
  String get qrGuide_title;

  /// No description provided for @qrGuide_step1.
  ///
  /// In en, this message translates to:
  /// **'Download the NoRisk Client Launcher on your PC from norisk.gg/downloads.'**
  String get qrGuide_step1;

  /// No description provided for @qrGuide_step2.
  ///
  /// In en, this message translates to:
  /// **'Install it and log in with your Minecraft account.'**
  String get qrGuide_step2;

  /// No description provided for @qrGuide_step3.
  ///
  /// In en, this message translates to:
  /// **'Open the \"Social Accounts\" menu next to the account manager.'**
  String get qrGuide_step3;

  /// No description provided for @qrGuide_step4.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code shown there with this app.'**
  String get qrGuide_step4;

  /// No description provided for @qrGuide_scanNow.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code Now'**
  String get qrGuide_scanNow;

  /// No description provided for @qrGuide_later.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get qrGuide_later;

  /// No description provided for @qrGuide_helpLink.
  ///
  /// In en, this message translates to:
  /// **'How do I get a QR code?'**
  String get qrGuide_helpLink;

  /// No description provided for @signIn_error_invalid.
  ///
  /// In en, this message translates to:
  /// **'This QR code is invalid or has expired. Please generate a new one in the Launcher and try again.'**
  String get signIn_error_invalid;

  /// No description provided for @signIn_error_network.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the server. Check your internet connection and try again.'**
  String get signIn_error_network;

  /// No description provided for @signIn_continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue without an account'**
  String get signIn_continueAsGuest;

  /// No description provided for @navbar_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get navbar_login;

  /// No description provided for @settings_theme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_theme;

  /// No description provided for @settings_theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_theme_dark;

  /// No description provided for @settings_theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_theme_light;

  /// No description provided for @settings_customization.
  ///
  /// In en, this message translates to:
  /// **'Customization'**
  String get settings_customization;

  /// No description provided for @settings_borderRadius.
  ///
  /// In en, this message translates to:
  /// **'Border Radius'**
  String get settings_borderRadius;

  /// No description provided for @settings_accentColor.
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get settings_accentColor;

  /// No description provided for @settings_backgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Background Color'**
  String get settings_backgroundColor;

  /// No description provided for @settings_customBackgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Custom Background Color'**
  String get settings_customBackgroundColor;

  /// No description provided for @settings_customColor.
  ///
  /// In en, this message translates to:
  /// **'Custom Color'**
  String get settings_customColor;

  /// No description provided for @settings_savedColors.
  ///
  /// In en, this message translates to:
  /// **'Saved Colors (max. 7)'**
  String get settings_savedColors;

  /// No description provided for @settings_contributors.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get settings_contributors;

  /// No description provided for @settings_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settings_close;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it', 'ja', 'ko', 'pl', 'pt', 'ru', 'tr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
    case 'zh': {
  switch (locale.countryCode) {
    case 'CN': return AppLocalizationsZhCn();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'tr': return AppLocalizationsTr();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
