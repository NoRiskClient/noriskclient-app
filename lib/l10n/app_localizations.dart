import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
  ];

  /// The name of the language as displayed to the user. This should be in the language itself. E.g. 'Deutsch' for German, etc.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeDisplay;

  /// Navbar label for the current user's tab.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get navbarYou;

  /// Legal notice shown on the sign-in screen.
  ///
  /// In en, this message translates to:
  /// **'By signing in you agree to the terms of service and privacy policy.'**
  String get signInEula;

  /// Explanation text on how to sign in using a QR code.
  ///
  /// In en, this message translates to:
  /// **'To sign in, scan the QR code from the NoRiskClient Launcher under the menu option \'Social Accounts\' next to the account manager.'**
  String get signInExplanation;

  /// Button label for scanning a QR code. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get signInScanQrCode;

  /// Primary sign-in button label. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInLabel;

  /// Status text shown while the sign-in process is running.
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get signInSigningIn;

  /// Settings screen title. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Action to sign out the current user. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get settingsSignOut;

  /// Entry in settings to change the app language. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Entry in settings showing/manage blocked players. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Blocked Players'**
  String get settingsBlockedPlayers;

  /// Entry in settings for legal information (imprint, privacy, terms). Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get settingsLegal;

  /// Link to the terms of service page. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTos;

  /// Link to the privacy policy page. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// Link to the imprint page. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Imprint'**
  String get settingsImprint;

  /// Link to the support page. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// Title shown on your own profile. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Your Profile'**
  String get profileYourProfile;

  /// Suffix used to display another user's profile title, e.g., 'Alex's Profile'. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'\'s Profile'**
  String get profileUsersProfile;

  /// Profile stats label for the user's first join date. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'First Join'**
  String get profileStatsFirstJoin;

  /// Profile stats label for the user's last join date. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Last Join'**
  String get profileStatsLastJoin;

  /// Profile stats label for login streak days. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Login Streak'**
  String get profileStatsLoginStreak;

  /// Profile stats label for the user's McReal posting streak. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'McReal Streak'**
  String get profileStatsMcReal;

  /// Profile stats label for the user's total playtime. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Playtime'**
  String get profileStatsPlaytime;

  /// Suffix shown when a user has no pinned posts.
  ///
  /// In en, this message translates to:
  /// **' doesn\'t have any pinned posts :/'**
  String get profileNoPinnedPosts;

  /// Filter/tab label for friends-only posts. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get mcRealFriendsTabLabel;

  /// Tab label for discovery posts. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get mcRealDiscoverTabLabel;

  /// Filter/tab label for partner posts. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Partners'**
  String get mcRealPartnersTabLabel;

  /// Header for the user's own McReal. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Your McReal'**
  String get mcRealYourMcReal;

  /// Relative time label for events that happened just now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get mcRealJustNow;

  /// Relative time suffix, e.g., '13h ago'.
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  String mcRealAgo(String time);

  /// Action label to add a comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get mcRealCommentLabel;

  /// Placeholder/hint for creating a new comment. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'New Comment'**
  String get mcRealCommentHint;

  /// Shown when there are no comments for a post.
  ///
  /// In en, this message translates to:
  /// **'No comments available.'**
  String get mcRealNoComments;

  /// Action to reply to a comment.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get mcRealReply;

  /// Label next to a single reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get mcRealCommentReply;

  /// Label for multiple replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get mcRealCommentReplies;

  /// Avatar/author label meaning the current user.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get mcRealCommentYou;

  /// Shown when the feed has no posts for today.
  ///
  /// In en, this message translates to:
  /// **'Nobody has posted their McReal yet.\nStart NoRiskClient to be the first!'**
  String get mcRealNoPosts;

  /// Compact info when there are no posts to show.
  ///
  /// In en, this message translates to:
  /// **'No posts available :('**
  String get mcRealNoPostsPlain;

  /// Title of the delete comment confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcRealDeleteCommentTitle;

  /// Body of the delete comment confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment?'**
  String get mcRealDeleteCommentContent;

  /// Title of the delete McReal confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcRealDeletePostTitle;

  /// Body of the delete McReal confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete today\'s McReal?\nYou will not be able to post another McReal today!'**
  String get mcRealDeletePostContent;

  /// Title of the pin McReal confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcRealPinPostTitle;

  /// Body of the pin McReal confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to pin today\'s McReal?'**
  String get mcRealPinPostContent;

  /// Title of the unpin McReal confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcRealUnpinPostTitle;

  /// Body of the unpin McReal confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you no longer want to pin this McReal?'**
  String get mcRealUnpinPostContent;

  /// Generic cancel button in popups.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get mcRealPopupCancel;

  /// Generic delete action in popups.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get mcRealPopupDelete;

  /// Generic OK action in popups.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get mcRealPopupOk;

  /// Generic YES action in popups.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get mcRealPopupYes;

  /// Specific pin action label.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get mcRealPopupPin;

  /// Specific unpin action label.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get mcRealPopupUnpin;

  /// Info banner shown when the user's McReal was removed.
  ///
  /// In en, this message translates to:
  /// **'Your McReal was removed.\nTap here for more information.'**
  String get mcRealRemovedPostInfo;

  /// Title of the removed McReal popup. Note: Sentence case.
  ///
  /// In en, this message translates to:
  /// **'Your McReal was removed'**
  String get mcRealRemovedPostTitle;

  /// Label for the reason displayed when a McReal was removed. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get mcRealRemovedPostReason;

  /// Status text indicating the user's post has been deleted.
  ///
  /// In en, this message translates to:
  /// **'You have deleted your post.'**
  String get mcRealStatusDeleted;

  /// Status text indicating the user hasn't posted today.
  ///
  /// In en, this message translates to:
  /// **'You have not yet posted your McReal of today.'**
  String get mcRealStatusNoPost;

  /// Status text indicating the user's McReal was removed.
  ///
  /// In en, this message translates to:
  /// **'Your McReal was removed.'**
  String get mcRealStatusRemoved;

  /// Notice shown in profile view when the user hasn't posted a McReal yet.
  ///
  /// In en, this message translates to:
  /// **'You have to post a McReal before you can see others.'**
  String get mcRealProfileNotPosted;

  /// Primary action/button to report a post or comment. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get mcRealReportLabel;

  /// Dialog title when reporting a comment. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Report Comment'**
  String get mcRealReportCommentTitle;

  /// Dialog title when reporting a post. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Report Post'**
  String get mcRealReportPostTitle;

  /// Prompt label for describing the incident.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get mcRealReportWhatHappened;

  /// Hint/placeholder for optional additional information field. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get mcRealReportInfoHint;

  /// Report reason option. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Copyright Infringement'**
  String get mcRealReportReasonCopyrightInfringement;

  /// Report reason option. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Hate Speech'**
  String get mcRealReportReasonHateSpeech;

  /// Report reason option. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate For Minors'**
  String get mcRealReportReasonInappropriateForMinors;

  /// Report reason option. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Obscenity'**
  String get mcRealReportReasonObscenity;

  /// Report reason option for other/unspecified reasons. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get mcRealReportReasonOther;

  /// Report reason option. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Privacy Violation'**
  String get mcRealReportReasonPrivacyViolation;

  /// Report reason option.
  ///
  /// In en, this message translates to:
  /// **'Spam or Fraud'**
  String get mcRealReportReasonSpamOrFraud;

  /// Title of the post details page. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Post Details'**
  String get postDetailsTitle;

  /// Header labelling that the post is the user's McReal. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Your McReal'**
  String get postDetailsYourMcReal;

  /// Title of the delete message confirmation dialog. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get chatDeleteMessageTitle;

  /// Body of the delete message confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get chatDeleteMessageContent;

  /// Replacement text shown for a deleted message.
  ///
  /// In en, this message translates to:
  /// **'This message was deleted.'**
  String get chatMessageDeleted;

  /// Placeholder text when a chat has no messages. Note: Title case.
  ///
  /// In en, this message translates to:
  /// **'Empty Chat'**
  String get chatEmpty;

  /// Shown when there is no Gamescom information to display.
  ///
  /// In en, this message translates to:
  /// **'There is no information available at the moment.'**
  String get gamescomNoInfo;

  /// Title of the block user confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcRealBlockUserTitle;

  /// Body of the block user confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block this player?'**
  String get mcRealBlockUserContent;

  /// Title of the unblock user confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get mcRealUnblockUserTitle;

  /// Body of the unblock user confirmation dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unblock this player?'**
  String get mcRealUnblockUserContent;

  /// Info text shown on a blocked player's profile.
  ///
  /// In en, this message translates to:
  /// **'You have blocked this player.'**
  String get mcRealBlockedPlayer;

  /// Shown in the blocked players list when it is empty.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any blocked players.'**
  String get mcRealBlockedNone;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
