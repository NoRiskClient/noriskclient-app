import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoRiskContainer extends Container {
  NoRiskContainer({
    Key? key,
    double? width,
    double? height,
    Color? color,
    int? backgroundOpacity,
    int? borderOpacity,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    BoxConstraints? constraints,
    Decoration? decoration,
    Widget? child,
  }) : super(
         key: key,
         width: width,
         height: height,
         alignment: alignment,
         padding: padding,
         constraints: constraints,
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
         child: child,
       );
}
