import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noriskclient/config/colors.dart';

class NRIcons {
  NRIcons._();

  static Color get _themeColor =>
      NoRiskClientColors.mode == NoRiskThemeMode.dark
          ? Colors.white
          : Colors.black;

  static Widget svg(
    String name, {
    Color? color,
    double size = 24,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    String dir = 'icons',
  }) {
    final tint = color ?? _themeColor;
    return SvgPicture.asset(
      'lib/assets/$dir/$name.svg',
      width: width ?? size,
      height: height ?? size,
      fit: fit,
      colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
    );
  }

  static Widget svgAsset(
    String assetPath, {
    Color? color,
    double size = 24,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    final tint = color ?? _themeColor;
    return SvgPicture.asset(
      assetPath,
      width: width ?? size,
      height: height ?? size,
      fit: fit,
      colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
    );
  }

  static Widget get(
    String name, {
    Color? color,
    double size = 24,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    String ext = 'png',
  }) {
    return Image.asset(
      'lib/assets/icons/$name.$ext',
      width: width ?? size,
      height: height ?? size,
      fit: fit,
      color: color ?? _themeColor,
      colorBlendMode: BlendMode.srcIn,
    );
  }

  static Widget nav(
    String name, {
    Color? color,
    double size = 25,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    String ext = 'png',
  }) {
    return Image.asset(
      'lib/assets/widgets/$name.$ext',
      width: width ?? size,
      height: height ?? size,
      fit: fit,
      color: color ?? _themeColor,
      colorBlendMode: BlendMode.srcIn,
    );
  }

  static Widget raw(
    String name, {
    String dir = 'icons',
    double size = 24,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    String ext = 'png',
  }) {
    return Image.asset(
      'lib/assets/$dir/$name.$ext',
      width: width ?? size,
      height: height ?? size,
      fit: fit,
    );
  }
}

class NoRiskIcon {
  static Image delete = Image.asset(
    'lib/assets/icons/delete.png',
    height: 20,
    width: 15,
    fit: BoxFit.fill,
  );
  static Image comment = Image.asset(
    'lib/assets/icons/comment.png',
    height: 30,
    width: 30,
    fit: BoxFit.fill,
  );
  static Image upvote = Image.asset(
    'lib/assets/icons/upvote.png',
    height: 17.5,
    width: 20,
    fit: BoxFit.fill,
  );
  static Image downvote = Image.asset(
    'lib/assets/icons/downvote.png',
    height: 17.5,
    width: 20,
    fit: BoxFit.fill,
  );
  static Image upvoted = Image.asset(
    'lib/assets/icons/upvoted.png',
    height: 17.5,
    width: 20,
    fit: BoxFit.fill,
  );
  static Image downvoted = Image.asset(
    'lib/assets/icons/downvoted.png',
    height: 17.5,
    width: 20,
    fit: BoxFit.fill,
  );
  static Widget reload = NRIcons.svgAsset(
    'lib/assets/icons/reload.svg',
    size: 25,
  );
  static Image report = Image.asset(
    'lib/assets/icons/report.png',
    height: 30,
    width: 30,
    fit: BoxFit.fill,
  );
  static Image lock = Image.asset(
    'lib/assets/icons/lock.png',
    height: 32.5,
    width: 30,
    fit: BoxFit.fill,
  );
  static Image streak = Image.asset(
    'lib/assets/icons/fire.webp',
    height: 25,
    width: 25,
    fit: BoxFit.fill,
  );
  static Image settings = Image.asset(
    'lib/assets/icons/settings.png',
    height: 20,
    width: 20,
    fit: BoxFit.fill,
  );
  static Image checkmark = Image.asset(
    'lib/assets/icons/checkmark.png',
    height: 20,
    width: 20,
    fit: BoxFit.fill,
  );
  static Image blue_checkmark = Image.asset(
    'lib/assets/icons/blue_checkmark.png',
    height: 20,
    width: 20,
    fit: BoxFit.fill,
  );

  static Image news = Image.asset(
    'lib/assets/widgets/news.png',
    height: 25,
    width: 25,
    fit: BoxFit.fill,
  );
  static Image chats = Image.asset(
    'lib/assets/widgets/chats.png',
    height: 25,
    width: 25,
    fit: BoxFit.fill,
  );
  static Image mcreal = Image.asset(
    'lib/assets/widgets/mcreal.png',
    height: 25,
    width: 25,
    fit: BoxFit.fill,
  );
  static Image friends = Image.asset(
    'lib/assets/widgets/friends.png',
    height: 25,
    width: 25,
    fit: BoxFit.fill,
  );
  static Image profile = Image.asset(
    'lib/assets/widgets/profile.png',
    height: 25,
    width: 25,
    fit: BoxFit.fill,
  );

  static Image gamescom = Image.asset(
    'lib/assets/widgets/gamescom.png',
    height: 25,
    width: 25,
    fit: BoxFit.fill,
  );
}
