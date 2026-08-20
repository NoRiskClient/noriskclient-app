import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noriskclient/config/colors.dart';

class NoRiskContainer extends Container {
  NoRiskContainer({
    super.key,
    super.width,
    super.height,
    Color? color,
    int? backgroundOpacity,
    int? borderOpacity,
    super.alignment,
    super.padding,
    super.constraints,
    Decoration? decoration,
    BorderRadius? borderRadius,
    bool elevated = false,
    super.child,
  }) : super(
          decoration: decoration ??
              BoxDecoration(
                color: color == Colors.transparent
                    ? color
                    : color != null
                        ? color.withAlpha(backgroundOpacity ?? 255)
                        : NoRiskClientColors.surface,
                 borderRadius: borderRadius ??
                     BorderRadius.circular(NoRiskClientColors.borderRadius),
                border: Border.all(
                  color: color == Colors.transparent
                      ? color!
                      : color != null
                          ? color.withAlpha(borderOpacity ?? 100)
                          : NoRiskClientColors.light.withAlpha(160),
                  width: 1.5,
                ),
                boxShadow: elevated
                    ? [
                        BoxShadow(
                          color: NoRiskClientColors.darkerBackground
                              .withAlpha(90),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
        );
}
