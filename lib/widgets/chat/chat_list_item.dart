import 'dart:async';

import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/screens/chat/chat.dart';
import 'package:noriskclient/services/api_client.dart';
import 'package:noriskclient/widgets/common/loading_indicator.dart';
import 'package:noriskclient/widgets/common/nr_container.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

class ChatListItem extends StatefulWidget {
  String chatId;
  String participantId;
  String? lastMessage;
  int? lastMessageTimestamp;
  int unreadMessages;
  StreamController<String> chatUpdateStream;

  ChatListItem({
    super.key,
    required this.chatId,
    required this.participantId,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.unreadMessages,
    required this.chatUpdateStream,
  });

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  @override
  void initState() {
    getUpdateStream.sink.add([
      'loadSkin',
      widget.participantId,
      () => setState(() {
            cache = getCache;
          })
    ]);
    NoRiskApi().getUserProfile(widget.participantId).then((Map profile) {
      setState(() {
        cache = getCache;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: openChat,
        child: NoRiskContainer(
          height: 85,
          width: MediaQuery.of(context).size.width - 2 * 15,
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            GestureDetector(
              onTap: openChat,
              child: SizedBox(
                height: 65,
                width: 65,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: cache['skins']?[widget.participantId] ??
                        LoadingIndicator()),
              ),
            ),
            const SizedBox(width: 10),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width -
                        2 * 15 -
                        2 * 10 -
                        65 -
                        10 -
                        5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NoRiskText(
                          cache['profiles']?[widget.participantId]?['nrcUser']
                                      ?['ign']
                                  ?.toString() ??
                              '',
                          maxLength: MediaQuery.of(context).size.width -
                              2 * 15 -
                              2 * 15 -
                              65 -
                              110 +
                              () {
                                DateTime lastMessageDateTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        widget.lastMessageTimestamp ?? 0);

                                if (lastMessageDateTime.day ==
                                        DateTime.now().day &&
                                    lastMessageDateTime.month ==
                                        DateTime.now().month &&
                                    lastMessageDateTime.year ==
                                        DateTime.now().year) {
                                  return 75;
                                } else {
                                  return 0;
                                }
                              }(),
                          spaceTop: false,
                          spaceBottom: false,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: NoRiskClientColors.text),
                        ),
                        if (widget.lastMessageTimestamp != null)
                          NoRiskText(getLastMessageTimestampString(),
                              spaceTop: false,
                              spaceBottom: false,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  color: NoRiskClientColors.text)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  NoRiskText(
                    widget.lastMessage != null && widget.lastMessage!.isNotEmpty
                        ? widget.lastMessage!
                        : AppLocalizations.of(context)!.chat_chat_empty,
                    spaceTop: false,
                    spaceBottom: false,
                    maxLength: MediaQuery.of(context).size.width -
                        2 * 15 -
                        2 * 10 -
                        65 -
                        10 -
                        50,
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 10, color: NoRiskClientColors.text),
                  ),
                ])
          ]),
        ),
      ),
    );
  }

  void openChat() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Chat(
        chatId: widget.chatId,
        participantId: widget.participantId,
        chatUpdateStream: widget.chatUpdateStream,
      ),
    ));
  }

  String getLastMessageTimestampString() {
    DateTime lastMessageDateTime =
        DateTime.fromMillisecondsSinceEpoch(widget.lastMessageTimestamp!);

    if (lastMessageDateTime.day == DateTime.now().day &&
        lastMessageDateTime.month == DateTime.now().month &&
        lastMessageDateTime.year == DateTime.now().year) {
      return '${lastMessageDateTime.hour.toString().padLeft(2, '0')}:${lastMessageDateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${lastMessageDateTime.day.toString().padLeft(2, '0')}.${lastMessageDateTime.month.toString().padLeft(2, '0')}.${lastMessageDateTime.year}';
    }
  }
}
