import 'package:flutter/material.dart';

import 'no_risk_container.dart';
import 'no_risk_text.dart';

class NoRiskBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const NoRiskBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: NoRiskContainer(
        width: 30,
        height: 30,
        child: Center(
          child: NoRiskText(
            '←',
            spaceTop: false,
            spaceBottom: true,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
