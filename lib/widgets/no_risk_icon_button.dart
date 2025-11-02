import 'package:flutter/material.dart';
import 'no_risk_container.dart';

class NoRiskIconButton extends StatelessWidget {
  final Widget icon;
  final bool transparent;
  final void Function() onTap;
  final double width;
  final double height;

  const NoRiskIconButton({
    super.key,
    required this.onTap,
    this.transparent = false,
    required this.icon,
    this.width = 30,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NoRiskContainer(
        width: width,
        height: height,
        color: transparent ? Colors.transparent : Colors.white,
        child: Center(child: icon),
      ),
    );
  }
}
