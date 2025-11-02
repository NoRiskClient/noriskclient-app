import 'package:flutter/material.dart';

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
    super.child,
  }) : super(
         decoration: BoxDecoration(
           color: color == Colors.transparent
               ? color
               : color?.withAlpha(backgroundOpacity ?? 115) ??
                     Colors.white.withAlpha(backgroundOpacity ?? 115),
           border: Border.all(
             color: color == Colors.transparent
                 ? color!
                 : color?.withAlpha(borderOpacity ?? 100) ??
                       Colors.white.withAlpha(borderOpacity ?? 100),
             width: 2,
           ),
         ),
       );
}
