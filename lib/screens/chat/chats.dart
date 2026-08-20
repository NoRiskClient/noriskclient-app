import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/screens/profile/profile.dart';
import 'package:noriskclient/services/blocking_manager.dart';
import 'package:noriskclient/services/api_client.dart';
import 'package:noriskclient/widgets/chat/chat_list_item.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => ChatsState();
}

class ChatsState extends State<Chats> {
  StreamController<String> chatUpdateStream = StreamController<String>();
  List<ChatListItem> chats = [];

  @override
  void initState() {
    loadChats();
    chatUpdateStream.stream.listen((String data) async {
      if (data == '*') {
        setState(() {
          chats = [];
        });
        loadChats();
        return;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    chatUpdateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: NoRiskClientColors.background,
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              chats = [];
            });
            loadChats();
          },
          child: ListView(
            children: [
              NoRiskText('chats',
                  spaceTop: false,
                  spaceBottom: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.5,
                      fontWeight: FontWeight.bold,
                      color: NoRiskClientColors.text)),
              chats.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 60, left: 32, right: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NoRiskText(
                            AppLocalizations.of(context)!.chats_noChats,
                            spaceTop: false,
                            spaceBottom: false,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: NoRiskClientColors.text,
                            ),
                          ),
                          const SizedBox(height: 8),
                          NoRiskText(
                            AppLocalizations.of(context)!
                                .chats_noChats_subtitle,
                            spaceTop: false,
                            spaceBottom: false,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              color: NoRiskClientColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [const SizedBox(height: 10), ...chats]),
                    ),
              const SizedBox(height: 80),
            ],
          ),
        ));
  }

  Future<void> loadChats() async {
    List<dynamic> chatsData = await NoRiskApi().getPrivateChats();

    List<ChatListItem> newChats = [];
    for (var chatData in chatsData) {
      String participantId = (chatData['participants'] as List)
          .firstWhere((p) => p['userId'] != userData['uuid'])['userId'];
      bool isBlocked = await BlockingManager().checkBlocked(participantId);

      if (isBlocked) continue;

      newChats.add(ChatListItem(
          chatId: chatData['_id'],
          participantId: participantId,
          lastMessage: chatData['latestMessage']?['content'] ?? '',
          lastMessageTimestamp: chatData['latestMessage']?['sentAt'],
          unreadMessages: chatData['unreadMessages'],
          chatUpdateStream: chatUpdateStream));
    }

    newChats.sort((a, b) {
      if (a.lastMessageTimestamp == null && b.lastMessageTimestamp == null) {
        return 0;
      } else if (a.lastMessageTimestamp == null) {
        return 1;
      } else if (b.lastMessageTimestamp == null) {
        return -1;
      }
      return b.lastMessageTimestamp!.compareTo(a.lastMessageTimestamp!);
    });

    await Future.delayed(const Duration(milliseconds: 10));
    setState(() {
      chats = newChats;
    });
  }

  void openProfilePage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => Profile(
            uuid: userData['uuid'],
            isSettings: true,
            postUpdateStream: chatUpdateStream)));
  }
}
