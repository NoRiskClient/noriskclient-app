import 'package:flutter/widgets.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/widgets/common/nr_container.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

class NoRiskProfileStatisticContainer extends StatelessWidget {
  const NoRiskProfileStatisticContainer({
    super.key,
    required this.title,
    required this.value,
    this.width,
  });

  final String title;
  final String value;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return NoRiskContainer(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: NoRiskText(
              value,
              spaceTop: false,
              spaceBottom: false,
              style: TextStyle(
                fontSize: 14,
                color: NoRiskClientColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: NoRiskText(
              title,
              spaceTop: false,
              spaceBottom: false,
              style: TextStyle(
                fontSize: 10,
                color: NoRiskClientColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
