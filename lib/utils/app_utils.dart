import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';

class AppUtils {
  AppUtils._();

  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 12;
  static const double spacingL = 16;
  static const double spacingXL = 24;
  static const double spacingXXL = 32;

  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 24;

  static TextStyle headline({double fontSize = 45}) => TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: NoRiskClientColors.text,
      );

  static TextStyle sectionLabel({double fontSize = 25}) => TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: NoRiskClientColors.text,
      );

  static TextStyle caption({double fontSize = 14}) => TextStyle(
        fontSize: fontSize,
        color: NoRiskClientColors.textLight,
      );

  static Widget emptyState({
    required String title,
    String? subtitle,
    Widget? icon,
    double topPadding = 60,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, left: 32, right: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon, const SizedBox(height: 16)],
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: NoRiskClientColors.text,
              fontFamily: 'SmallCapsMC',
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: NoRiskClientColors.textLight,
                fontFamily: 'SmallCapsMC',
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String relativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'gerade eben';
    if (diff.inMinutes < 60) return 'vor ${diff.inMinutes} Min.';
    if (diff.inHours < 24) return 'vor ${diff.inHours} Std.';
    if (diff.inDays == 1) return 'gestern';
    if (diff.inDays < 7) return 'vor ${diff.inDays} Tagen';
    return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
  }

  static String relativeTimeFromString(String? raw) {
    if (raw == null) return '';
    try {
      return relativeTime(DateTime.parse(raw).toLocal());
    } catch (_) {
      return '';
    }
  }

  static double clamp(double value, double min, double max) =>
      value < min ? min : (value > max ? max : value);

  static String truncate(String text, int maxLength) =>
      text.length <= maxLength ? text : '${text.substring(0, maxLength)}…';
}
