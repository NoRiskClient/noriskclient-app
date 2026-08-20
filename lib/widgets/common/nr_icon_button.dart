import 'package:flutter/material.dart';
import 'package:noriskclient/widgets/common/nr_container.dart';

class NoRiskIconButton extends StatelessWidget {
  NoRiskIconButton(
      {super.key,
      required this.onTap,
      this.transparent = false,
      required this.icon,
      this.width = 30,
      this.height = 30});

  final Widget icon;
  final bool transparent;
  final void Function() onTap;
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NoRiskContainer(
          width: width,
          height: height,
          color: transparent ? Colors.transparent : null,
          child: Center(child: icon)),
    );
  }
}
