import 'package:flutter/widgets.dart';
import 'package:noriskclient/config/Colors.dart';
import 'package:noriskclient/widgets/NoRiskContainer.dart';
import 'package:noriskclient/widgets/NoRiskText.dart';

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
      height: MediaQuery.of(context).size.width * 0.15,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoRiskText(
            value.toLowerCase(),
            spaceTop: false,
            spaceBottom: false,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.125,
              color: NoRiskClientColors.text,
            ),
          ),
          NoRiskText(
            title.toLowerCase(),
            spaceTop: false,
            spaceBottom: false,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: NoRiskClientColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
