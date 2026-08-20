import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/utils/nr_icons.dart';
import 'package:noriskclient/widgets/common/nr_container.dart';

class NoRiskBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NoRiskBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: NoRiskContainer(
        width: 32,
        height: 32,
        child: Center(
          child: NRIcons.svg('back', color: NoRiskClientColors.text, size: 18),
        ),
      ),
    );
  }
}
