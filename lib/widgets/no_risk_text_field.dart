import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../config/config.dart';
import 'no_risk_container.dart';
import 'no_risk_text.dart';

class NoRiskTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextStyle? style;
  final InputDecoration? decoration;
  final int maxLines;
  final TextAlign textAlign;
  final bool hasSendButton;
  final double width;
  final Function(String, bool)? onSubmitted;

  const NoRiskTextField({
    super.key,
    required this.controller,
    required this.width,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.style,
    this.decoration,
    this.maxLines = 99999,
    this.textAlign = TextAlign.start,
    this.hasSendButton = false,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return NoRiskContainer(
      padding: const EdgeInsets.only(left: 5, right: 5),
      constraints: BoxConstraints(
        maxHeight: 60,
        minHeight: 60,
        maxWidth: width,
        minWidth: width,
      ),
      child: Row(
        children: [
          TextField(
            decoration: InputDecoration(
              constraints: BoxConstraints(
                minHeight: 70,
                maxHeight: 70,
                maxWidth: width - (hasSendButton ? 80 : 0),
                minWidth: width - (hasSendButton ? 80 : 0),
              ),
              contentPadding: EdgeInsets.all(0),
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hint: NoRiskText(
                hintText?.toLowerCase() ?? '',
                spaceTop: false,
                spaceBottom: false,
                style: const TextStyle(
                  color: NoRiskClientColors.text,
                  fontSize: 20,
                ),
              ),
              counter: SizedBox(width: 0, height: 0),
              counterStyle: const TextStyle(
                fontFamily: 'SmallCapsMC',
                color: Colors.white,
                fontSize: 17.5,
              ),
            ),
            minLines: 1,
            enabled: true,
            maxLines: 5,
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.text,
            maxLength: Config.maxCommentContentLength,
            cursorHeight: 10,
            style: const TextStyle(
              fontFamily: 'SmallCapsMC',
              color: NoRiskClientColors.text,
              fontSize: 25,
              height: 0.5,
            ),
            canRequestFocus: true,
            onSubmitted: (value) =>
                onSubmitted != null ? onSubmitted!(value, false) : null,
            onEditingComplete: () => focusNode?.unfocus(),
            onTapOutside: (e) => focusNode?.unfocus(),
          ),
          if (hasSendButton) const SizedBox(width: 5),
          if (hasSendButton)
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: GestureDetector(
                onTap: onSubmitted != null
                    ? () => onSubmitted!(controller.text, true)
                    : null,
                child: NoRiskContainer(
                  width: 50,
                  color: NoRiskClientColors.blue,
                  padding: const EdgeInsets.only(bottom: 2.5),
                  child: Center(
                    child: NoRiskText(
                      'send',
                      spaceTop: false,
                      spaceBottom: false,
                      style: const TextStyle(
                        color: NoRiskClientColors.text,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
