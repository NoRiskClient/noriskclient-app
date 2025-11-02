import 'package:flutter/material.dart';
import 'package:noriskclient/widgets/no_risk_container.dart';

class NoRiskButton extends StatelessWidget {
  NoRiskButton({
    super.key,
    this.height,
    this.width,
    this.color = Colors.white,
    required this.onTap,
    required this.child,
  });

  final Widget child;
  Color color;
  final void Function() onTap;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NoRiskContainer(
        height: height,
        width: width,
        color: color,
        padding: const EdgeInsets.all(2.5),
        child: Center(child: child),
      ),
    );
  }
}
