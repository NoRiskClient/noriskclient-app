import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/config/config.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/services/api_client.dart';

class McRealCommentInput extends StatefulWidget {
  const McRealCommentInput(
      {super.key,
      required this.userData,
      required this.postId,
      this.parentCommentId,
      required this.refresh});

  final Map<String, dynamic> userData;
  final String postId;
  final String? parentCommentId;
  final Function() refresh;

  @override
  State<McRealCommentInput> createState() => McRealCommentInputState();
}

class McRealCommentInputState extends State<McRealCommentInput> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode commentFocus = FocusNode();
  bool hasFocus = false;

  @override
  void initState() {
    commentFocus.addListener(() {
      setState(() {
        hasFocus = commentFocus.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 35),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    (widget.parentCommentId != null ? 0.7 : 0.925),
                height: hasFocus ? 100 : 55,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          NoRiskClientColors.borderRadius,
                        ),
                        borderSide: BorderSide(
                            color: NoRiskClientColors.light, width: 2)),
                    fillColor: NoRiskClientColors.background,
                    labelText:
                        AppLocalizations.of(context)!.mcReal_comment_hint,
                    labelStyle: TextStyle(color: NoRiskClientColors.text),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          NoRiskClientColors.borderRadius,
                        ),
                        gapPadding: 3.5,
                        borderSide: BorderSide(
                            color: NoRiskClientColors.blue, width: 2)),
                    filled: true,
                    isDense: true,
                  ),
                  enabled: true,
                  maxLines: 3,
                  controller: commentController,
                  focusNode: commentFocus,
                  keyboardType: TextInputType.text,
                  maxLength: Config.maxCommentContentLength,
                  cursorHeight: 12.5,
                  style:
                      TextStyle(color: NoRiskClientColors.text, fontSize: 10),
                  autofocus: true,
                  canRequestFocus: true,
                  scrollPadding: const EdgeInsets.all(0),
                  onSubmitted: (value) => create(value),
                  onTapOutside: (event) => commentFocus.unfocus(),
                ),
              )
            ]));
  }

  Future<void> create(String content) async {
    if (content.isEmpty) return;

    http.Response res = await http.post(
        Uri.parse(
            '${NoRiskApi().getBaseUrl(widget.userData['experimental'], 'mcreal')}/comments?uuid=${widget.userData['uuid']}&postId=${widget.postId}${widget.parentCommentId != null ? '&parentCommentId=${widget.parentCommentId}' : ''}&text=$content'),
        headers: {'Authorization': 'Bearer ${widget.userData['token']}'});
    if (res.statusCode != 200) {
      if (res.statusCode == 401) {
        Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    widget.refresh();
  }
}
