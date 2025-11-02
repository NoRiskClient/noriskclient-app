// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localeDisplay => 'English';

  @override
  String get navbarYou => 'You';

  @override
  String get signInEula =>
      'By signing in you agree to the terms of service and privacy policy.';

  @override
  String get signInExplanation =>
      'To sign in, scan the QR code from the NoRiskClient Launcher under the menu option \'Social Accounts\' next to the account manager.';

  @override
  String get signInScanQrCode => 'Scan QR Code';

  @override
  String get signInLabel => 'Sign In';

  @override
  String get signInSigningIn => 'Signing In...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSignOut => 'Sign Out';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsBlockedPlayers => 'Blocked Players';

  @override
  String get settingsLegal => 'Legal';

  @override
  String get settingsTos => 'Terms of Service';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsImprint => 'Imprint';

  @override
  String get settingsSupport => 'Support';

  @override
  String get profileYourProfile => 'Your Profile';

  @override
  String get profileUsersProfile => '\'s Profile';

  @override
  String get profileStatsFirstJoin => 'First Join';

  @override
  String get profileStatsLastJoin => 'Last Join';

  @override
  String get profileStatsLoginStreak => 'Login Streak';

  @override
  String get profileStatsMcReal => 'McReal Streak';

  @override
  String get profileStatsPlaytime => 'Playtime';

  @override
  String get profileNoPinnedPosts => ' doesn\'t have any pinned posts :/';

  @override
  String get mcRealFriendsTabLabel => 'Friends';

  @override
  String get mcRealDiscoverTabLabel => 'Discover';

  @override
  String get mcRealPartnersTabLabel => 'Partners';

  @override
  String get mcRealYourMcReal => 'Your McReal';

  @override
  String get mcRealJustNow => 'Now';

  @override
  String mcRealAgo(String time) {
    return '$time late';
  }

  @override
  String get mcRealCommentLabel => 'Comment';

  @override
  String get mcRealCommentHint => 'New Comment';

  @override
  String get mcRealNoComments => 'No comments available.';

  @override
  String get mcRealReply => 'Reply';

  @override
  String get mcRealCommentReply => 'Reply';

  @override
  String get mcRealCommentReplies => 'Replies';

  @override
  String get mcRealCommentYou => 'You';

  @override
  String get mcRealNoPosts =>
      'Nobody has posted their McReal yet.\nStart NoRiskClient to be the first!';

  @override
  String get mcRealNoPostsPlain => 'No posts available :(';

  @override
  String get mcRealDeleteCommentTitle => 'Are you sure?';

  @override
  String get mcRealDeleteCommentContent =>
      'Are you sure you want to delete this comment?';

  @override
  String get mcRealDeletePostTitle => 'Are you sure?';

  @override
  String get mcRealDeletePostContent =>
      'Are you sure you want to delete today\'s McReal?\nYou will not be able to post another McReal today!';

  @override
  String get mcRealPinPostTitle => 'Are you sure?';

  @override
  String get mcRealPinPostContent =>
      'Are you sure you want to pin today\'s McReal?';

  @override
  String get mcRealUnpinPostTitle => 'Are you sure?';

  @override
  String get mcRealUnpinPostContent =>
      'Are you sure you no longer want to pin this McReal?';

  @override
  String get mcRealPopupCancel => 'Cancel';

  @override
  String get mcRealPopupDelete => 'Delete';

  @override
  String get mcRealPopupOk => 'OK';

  @override
  String get mcRealPopupYes => 'Yes';

  @override
  String get mcRealPopupPin => 'Pin';

  @override
  String get mcRealPopupUnpin => 'Unpin';

  @override
  String get mcRealRemovedPostInfo =>
      'Your McReal was removed.\nTap here for more information.';

  @override
  String get mcRealRemovedPostTitle => 'Your McReal was removed';

  @override
  String get mcRealRemovedPostReason => 'Reason';

  @override
  String get mcRealStatusDeleted => 'You have deleted your post.';

  @override
  String get mcRealStatusNoPost =>
      'You have not yet posted your McReal of today.';

  @override
  String get mcRealStatusRemoved => 'Your McReal was removed.';

  @override
  String get mcRealProfileNotPosted =>
      'You have to post a McReal before you can see others.';

  @override
  String get mcRealReportLabel => 'Report';

  @override
  String get mcRealReportCommentTitle => 'Report Comment';

  @override
  String get mcRealReportPostTitle => 'Report Post';

  @override
  String get mcRealReportWhatHappened => 'What happened?';

  @override
  String get mcRealReportInfoHint => 'Additional Information';

  @override
  String get mcRealReportReasonCopyrightInfringement =>
      'Copyright Infringement';

  @override
  String get mcRealReportReasonHateSpeech => 'Hate Speech';

  @override
  String get mcRealReportReasonInappropriateForMinors =>
      'Inappropriate For Minors';

  @override
  String get mcRealReportReasonObscenity => 'Obscenity';

  @override
  String get mcRealReportReasonOther => 'Other';

  @override
  String get mcRealReportReasonPrivacyViolation => 'Privacy Violation';

  @override
  String get mcRealReportReasonSpamOrFraud => 'Spam or Fraud';

  @override
  String get postDetailsTitle => 'Post Details';

  @override
  String get postDetailsYourMcReal => 'Your McReal';

  @override
  String get chatDeleteMessageTitle => 'Delete Message';

  @override
  String get chatDeleteMessageContent =>
      'Are you sure you want to delete this message?';

  @override
  String get chatMessageDeleted => 'This message was deleted.';

  @override
  String get chatEmpty => 'Empty Chat';

  @override
  String get gamescomNoInfo =>
      'There is no information available at the moment.';

  @override
  String get mcRealBlockUserTitle => 'Are you sure?';

  @override
  String get mcRealBlockUserContent =>
      'Are you sure you want to block this player?';

  @override
  String get mcRealUnblockUserTitle => 'Are you sure?';

  @override
  String get mcRealUnblockUserContent =>
      'Are you sure you want to unblock this player?';

  @override
  String get mcRealBlockedPlayer => 'You have blocked this player.';

  @override
  String get mcRealBlockedNone => 'You don\'t have any blocked players.';
}
