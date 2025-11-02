import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/Colors.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../utils/NoRiskApi.dart';
import '../utils/NoRiskIcon.dart';
import 'NoRiskContainer.dart';
import 'NoRiskText.dart';

enum MessageStatus { pending, sent, received, read }

class Message extends StatefulWidget {
  final String chatId;
  final String messageId;
  String content;
  final String senderId;
  final int sentAt;
  final MessageStatus status;
  bool isSpacer;
  final StreamController<String> chatUpdateStream;

  Message({
    super.key,
    required this.chatId,
    required this.messageId,
    required this.content,
    required this.senderId,
    required this.sentAt,
    required this.chatUpdateStream,
    this.status = MessageStatus.sent,
    this.isSpacer = false,
  });

  @override
  State<Message> createState() => MessageState();
}

class MessageState extends State<Message> {
  bool isSelected = false;
  bool isPressed = false;
  bool isDeleted = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: widget.isSpacer
          ? Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NoRiskContainer(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                      bottom: 2,
                    ),
                    child: Center(
                      child: NoRiskText(
                        widget.content,
                        spaceTop: false,
                        spaceBottom: false,
                        style: const TextStyle(
                          color: NoRiskClientColors.text,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: widget.senderId == getUserData['uuid']
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 2 * 15,
                      color: isSelected
                          ? NoRiskClientColors.blue.withOpacity(0.25)
                          : Colors.transparent,
                      child: Row(
                        children: [
                          if (widget.senderId == getUserData['uuid'])
                            const Spacer(),
                          GestureDetector(
                            onTapDown: (_) => setState(() {
                              isPressed = true;
                              isSelected = false;
                            }),
                            onTapUp: (_) => setState(() {
                              isPressed = false;
                            }),
                            onTapCancel: () => setState(() {
                              isPressed = false;
                            }),
                            onLongPressStart: (_) => setState(() {
                              if (!isDeleted) {
                                isSelected = true;
                              }
                            }),
                            child: NoRiskContainer(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                                minHeight: 30,
                                minWidth: 50,
                              ),
                              color: isPressed
                                  ? NoRiskClientColors.light.withOpacity(0.75)
                                  : isSelected
                                  ? NoRiskClientColors.blue
                                  : null,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 5,
                                      bottom: 12.5,
                                    ),
                                    child: NoRiskText(
                                      widget.content,
                                      spaceTop: false,
                                      spaceBottom: false,
                                      maxLines: 99,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        color: isPressed
                                            ? NoRiskClientColors.light
                                            : NoRiskClientColors.text,
                                        fontSize: 22.5,
                                        height: 0.75,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 2.5,
                                    child: Row(
                                      children: [
                                        NoRiskText(
                                          widget.sentAt != 0
                                              ? DateTime.fromMillisecondsSinceEpoch(
                                                      widget.sentAt,
                                                    )
                                                    .toLocal()
                                                    .toString()
                                                    .substring(11, 16)
                                              : '',
                                          spaceTop: false,
                                          spaceBottom: false,
                                          style: TextStyle(
                                            color: isPressed
                                                ? NoRiskClientColors.light
                                                : NoRiskClientColors.text,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                        if (widget.senderId ==
                                            getUserData['uuid'])
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                              left: 2,
                                            ),
                                            child: Opacity(
                                              opacity: isPressed ? 0.1 : 1.0,
                                              child: Stack(
                                                children: [
                                                  if (widget.status !=
                                                      MessageStatus.pending)
                                                    SizedBox(
                                                      width: 7.5,
                                                      height: 7.5,
                                                      child:
                                                          widget.status ==
                                                              MessageStatus.read
                                                          ? NoRiskIcon
                                                                .blue_checkmark
                                                          : NoRiskIcon
                                                                .checkmark,
                                                    ),
                                                  if (widget.status ==
                                                          MessageStatus
                                                              .received ||
                                                      widget.status ==
                                                          MessageStatus.read)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 2.5,
                                                          ),
                                                      child: SizedBox(
                                                        width: 7.5,
                                                        height: 7.5,
                                                        child:
                                                            widget.status ==
                                                                MessageStatus
                                                                    .read
                                                            ? NoRiskIcon
                                                                  .blue_checkmark
                                                            : NoRiskIcon
                                                                  .checkmark,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (widget.senderId != getUserData['uuid'])
                            const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: widget.senderId == getUserData['uuid']
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: (() {
                        bool isOwnMessage =
                            widget.senderId == getUserData['uuid'];
                        List<Widget> actions = [
                          if (isOwnMessage)
                            //   NoRiskContainer(
                            //       width: 30,
                            //       height: 30,
                            //       child: Center(
                            //           child: Icon(Icons.edit,
                            //               size: 17.5,
                            //               color: NoRiskClientColors.text))),
                            // if (isOwnMessage) const SizedBox(width: 5),
                            if (isOwnMessage)
                              GestureDetector(
                                onTap: deleteMessage,
                                child: NoRiskContainer(
                                  width: 30,
                                  height: 30,
                                  color: Colors.red,
                                  child: Center(
                                    child: SizedBox(
                                      height: 16.5,
                                      width: 13.5,
                                      child: NoRiskIcon.delete,
                                    ),
                                  ),
                                ),
                              ),
                        ];
                        return widget.senderId == getUserData['uuid']
                            ? actions
                            : actions.reversed.toList();
                      })(),
                    ),
                  ),
              ],
            ),
    );
  }

  void deleteMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isAndroid
            ? AlertDialog(
                title: NoRiskText(
                  AppLocalizations.of(context).chatDeleteMessageTitle,
                  spaceTop: false,
                  spaceBottom: false,
                ),
                content: NoRiskText(
                  AppLocalizations.of(context).chatDeleteMessageContent,
                  spaceTop: false,
                  spaceBottom: false,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: NoRiskText(
                      AppLocalizations.of(context).mcRealPopupCancel,
                      spaceTop: false,
                      spaceBottom: false,
                      style: const TextStyle(color: NoRiskClientColors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      NoRiskApi()
                          .deleteChatMessage(widget.chatId, widget.messageId)
                          .then((_) {
                            setState(() {
                              widget.content = AppLocalizations.of(
                                context,
                              ).chatMessageDeleted;
                              isSelected = false;
                              isDeleted = true;
                            });
                          });
                    },
                    child: NoRiskText(
                      AppLocalizations.of(context).mcRealPopupDelete,
                      spaceTop: false,
                      spaceBottom: false,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: NoRiskText(
                  AppLocalizations.of(context).chatDeleteMessageTitle,
                  spaceTop: false,
                  style: const TextStyle(fontSize: 30),
                ),
                content: NoRiskText(
                  AppLocalizations.of(context).chatDeleteMessageContent,
                  style: const TextStyle(fontSize: 17.5, height: 0.75),
                  spaceTop: false,
                  spaceBottom: false,
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () => Navigator.of(context).pop(),
                    child: NoRiskText(
                      AppLocalizations.of(context).mcRealPopupCancel,
                      style: const TextStyle(fontSize: 22.5),
                    ),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.of(context).pop();
                      NoRiskApi()
                          .deleteChatMessage(widget.chatId, widget.messageId)
                          .then((_) {
                            setState(() {
                              widget.content = AppLocalizations.of(
                                context,
                              ).chatMessageDeleted;
                              isSelected = false;
                              isDeleted = true;
                            });
                          });
                    },
                    child: NoRiskText(
                      AppLocalizations.of(context).mcRealPopupDelete,
                      style: const TextStyle(fontSize: 22.5),
                    ),
                  ),
                ],
              );
      },
    );
  }
}
