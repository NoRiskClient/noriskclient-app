import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:noriskclient/config/Colors.dart';
import 'package:noriskclient/utils/NoRiskIcon.dart';
import 'package:noriskclient/widgets/NoRiskContainer.dart';
import 'package:noriskclient/widgets/NoRiskText.dart';

// ignore: must_be_immutable
class NoRiskCheckbox extends StatefulWidget {
  NoRiskCheckbox({
    super.key,
    this.defaultValue = false,
    required this.onChanged,
    this.name = '',
  });

  bool defaultValue;
  Function(bool) onChanged = (bool value) {};
  String name;

  @override
  State<NoRiskCheckbox> createState() => McRealPostState();
}

class McRealPostState extends State<NoRiskCheckbox> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          value = !value;
        });
        widget.onChanged(value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoRiskContainer(
            width: 35,
            height: 35,
            child: Center(child: value ? NoRiskIcon.checkmark : Container()),
          ),
          const SizedBox(width: 10),
          if (widget.name.isNotEmpty)
            NoRiskText(
              widget.name.toLowerCase(),
              spaceTop: false,
              style: const TextStyle(
                fontSize: 25,
                color: NoRiskClientColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
