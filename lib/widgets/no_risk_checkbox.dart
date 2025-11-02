import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../utils/no_risk_icon.dart';
import 'no_risk_container.dart';
import 'no_risk_text.dart';

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
