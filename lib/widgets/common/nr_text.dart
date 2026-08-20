import 'package:flutter/widgets.dart';
import 'package:noriskclient/utils/string_utils.dart';

class NoRiskText extends Text {
  NoRiskText(
    String data, {
    Key? key,
    bool spaceBottom = true,
    bool spaceTop = true,
    TextAlign? textAlign,
    TextStyle? style,
    TextDirection? textDirection,
    double? maxLength,
    Locale? locale,
    bool softWrap = true,
    TextOverflow overflow = TextOverflow.clip,
    int? maxLines,
    StrutStyle? strutStyle,
  }) : super(
          StringUtils.enforceMaxLengthByPixels(
            data,
            maxLength != null ? maxLength.toDouble() : double.infinity,
            TextStyle(
                color: style?.color,
                fontSize: style?.fontSize,
                fontWeight: style?.fontWeight,
                fontFamily: 'SmallCapsMC'),
          ),
          key: key,
          style: TextStyle(
              color: style?.color,
              fontSize: style?.fontSize,
              fontWeight: style?.fontWeight,
              height: style?.height,
              fontFamily: 'SmallCapsMC'),
          textAlign: textAlign,
          textDirection: textDirection,
          textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: spaceTop, applyHeightToLastDescent: spaceBottom),
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          maxLines: maxLines,
          strutStyle: strutStyle,
        );
}