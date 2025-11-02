import 'dart:async';

import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../screens/chats/chat.dart';
import '../utils/no_risk_api.dart';
import 'no_risk_container.dart';
import 'no_risk_loading_indicator.dart';
import 'no_risk_text.dart';

class ChatListItem extends StatefulWidget {
  final String chatId;
  final String participantId;
  final String? lastMessage;
  final int? lastMessageTimestamp;
  final int unreadMessages;
  final StreamController<String> chatUpdateStream;

  const ChatListItem({
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
      }),
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
          child: Row(
            children: [
              GestureDetector(
                onTap: openChat,
                child: SizedBox(
                  height: 65,
                  width: 65,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child:
                        cache['skins']?[widget.participantId] ??
                        NoRiskLoadingIndicator(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    // LMAO ich bin mir noch nicht sicher, ob das cursed ist oder nicht? i mean eig ist es nicht clean aber ist ist ein cleaner weg das sizing zu berechnen ohne probleme mit Bildschirmgrößen zu bekommen :thinking:
                    width:
                        MediaQuery.of(context).size.width -
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
                          cache['profiles']?[widget
                                      .participantId]?['nrcUser']?['ign']
                                  ?.toString()
                                  .toLowerCase() ??
                              '',
                          maxLength:
                              MediaQuery.of(context).size.width -
                              2 * 15 -
                              2 * 15 -
                              65 -
                              110 +
                              () {
                                DateTime lastMessageDateTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                      widget.lastMessageTimestamp ?? 0,
                                    );

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
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: NoRiskClientColors.text,
                          ),
                        ),
                        if (widget.lastMessageTimestamp != null)
                          NoRiskText(
                            getLastMessageTimestampString(),
                            spaceTop: false,
                            spaceBottom: false,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 25,
                              color: NoRiskClientColors.text,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  NoRiskText(
                    widget.lastMessage != null && widget.lastMessage!.isNotEmpty
                        ? widget.lastMessage!.toLowerCase()
                        : AppLocalizations.of(context).chatEmpty,
                    spaceTop: false,
                    spaceBottom: false,
                    maxLength:
                        MediaQuery.of(context).size.width -
                        2 * 15 -
                        2 * 10 -
                        65 -
                        10 -
                        50, // 50 is added for padding to the right!
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 20,
                      color: NoRiskClientColors.text,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Chat(
          chatId: widget.chatId,
          participantId: widget.participantId,
          chatUpdateStream: widget.chatUpdateStream,
        ),
      ),
    );
  }

  String getLastMessageTimestampString() {
    DateTime lastMessageDateTime = DateTime.fromMillisecondsSinceEpoch(
      widget.lastMessageTimestamp!,
    );

    if (lastMessageDateTime.day == DateTime.now().day &&
        lastMessageDateTime.month == DateTime.now().month &&
        lastMessageDateTime.year == DateTime.now().year) {
      return '${lastMessageDateTime.hour.toString().padLeft(2, '0')}:${lastMessageDateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${lastMessageDateTime.day.toString().padLeft(2, '0')}.${lastMessageDateTime.month.toString().padLeft(2, '0')}.${lastMessageDateTime.year}';
    }
  }
}
