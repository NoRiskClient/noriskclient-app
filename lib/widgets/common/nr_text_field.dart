import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/config/config.dart';
import 'package:noriskclient/widgets/common/nr_container.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

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
          maxHeight: 64, minHeight: 64, maxWidth: width, minWidth: width),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                constraints: const BoxConstraints(
                  minHeight: 54,
                  maxHeight: 54,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hint: NoRiskText(
                  hintText ?? '',
                  spaceTop: false,
                  spaceBottom: false,
                  style: TextStyle(
                    color: NoRiskClientColors.text,
                    fontSize: 10,
                  ),
                ),
                counter: const SizedBox(width: 0, height: 0),
                counterStyle: TextStyle(
                    fontFamily: 'SmallCapsMC',
                    color: NoRiskClientColors.text,
                    fontSize: 10),
              ),
              minLines: 1,
              enabled: true,
              maxLines: 5,
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType ?? TextInputType.text,
              maxLength: Config.maxCommentContentLength,
              cursorHeight: 10,
              style: TextStyle(
                  fontFamily: 'SmallCapsMC',
                  color: NoRiskClientColors.text,
                  fontSize: 12.5,
                  height: 1.0),
              canRequestFocus: true,
              onSubmitted: (value) =>
                  onSubmitted != null ? onSubmitted!(value, false) : null,
              onEditingComplete: () => focusNode?.unfocus(),
              onTapOutside: (e) => focusNode?.unfocus(),
            ),
          ),
          if (hasSendButton) const SizedBox(width: 5),
          if (hasSendButton)
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              child: GestureDetector(
                onTap: onSubmitted != null
                    ? () => onSubmitted!(controller.text, true)
                    : null,
                child: NoRiskContainer(
                  width: 50,
                  color: NoRiskClientColors.blue,
                  padding: const EdgeInsets.only(bottom: 2.5),
                  child: Center(
                    child: NoRiskText('send',
                        spaceTop: false,
                        spaceBottom: false,
                        style: TextStyle(
                            color: NoRiskClientColors.text, fontSize: 10)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
