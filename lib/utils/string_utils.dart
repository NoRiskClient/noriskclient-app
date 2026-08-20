
import 'package:flutter/material.dart';

class StringUtils {
  static String enforceMaxLength(String value, int maxLength) {
    if (value.length > maxLength) {
      return '${value.substring(0, maxLength)}...';
    }
    return value;
  }

  static String enforceMaxLengthByPixels(
      String value, double maxWidth, TextStyle style) {
    String trimmedValue = value;

    TextSpan textSpan = TextSpan(text: value, style: style);
    TextPainter textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    while (textPainter.didExceedMaxLines) {
      if (trimmedValue.isEmpty) {
        return '';
      }
      trimmedValue = trimmedValue.substring(0, trimmedValue.length - 1);
      textSpan = TextSpan(text: trimmedValue, style: style);
      textPainter.text = textSpan;
      textPainter.layout(maxWidth: maxWidth);
    }

    return value.length > trimmedValue.length
        ? '${trimmedValue.trim()}...'
        : trimmedValue.trim();
  }
}