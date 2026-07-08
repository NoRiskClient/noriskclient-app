import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noriskclient/config/Colors.dart';
import 'package:noriskclient/config/Config.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/provider/localeProvider.dart';
import 'package:noriskclient/screens/chats/Chat.dart';
import 'package:noriskclient/utils/BlockingManager.dart';
import 'package:noriskclient/utils/NoRiskApi.dart';
import 'package:noriskclient/widgets/LoadingIndicator.dart';
import 'package:noriskclient/widgets/NoRiskButton.dart';
import 'package:noriskclient/widgets/NoRiskContainer.dart';
import 'package:noriskclient/widgets/NoRiskText.dart';
import 'package:noriskclient/widgets/NoRiskTextField.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => FriendsState();
}

class FriendsState extends State<Friends> {
  StreamController<String> chatUpdateStream = StreamController<String>();
  List<dynamic> friends = [];
  List<dynamic> incomingRequests = [];
  List<dynamic> outgoingRequests = [];
  Map<String, String> existingChatsByParticipant = {};
  bool isFriendsLoading = true;
  bool isRequestsLoading = true;
  int activeTab = 0;
  final TextEditingController addFriendController = TextEditingController();

  @override
  void initState() {
    loadLanguage();
    loadFriendsPageData();
    chatUpdateStream.stream.listen((String data) async {
      if (data == '*') {
        await loadPrivateChats();
        return;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    chatUpdateStream.close();
    addFriendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: NoRiskClientColors.background,
        body: Column(
          children: [
            SizedBox(height: isAndroid ? 60 : 55),
            NoRiskText('friends',
                spaceTop: false,
                spaceBottom: false,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: NoRiskClientColors.text)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: NoRiskButton(
                      onTap: () => setState(() => activeTab = 0),
                      color: activeTab == 0
                          ? NoRiskClientColors.blue
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: NoRiskText(
                          'friends list',
                          spaceTop: false,
                          spaceBottom: false,
                          style: TextStyle(
                              fontSize: 22,
                              color: activeTab == 0
                                  ? Colors.white
                                  : NoRiskClientColors.text),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: NoRiskButton(
                      onTap: () => setState(() => activeTab = 1),
                      color: activeTab == 1
                          ? NoRiskClientColors.blue
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: NoRiskText(
                          'requests',
                          spaceTop: false,
                          spaceBottom: false,
                          style: TextStyle(
                              fontSize: 22,
                              color: activeTab == 1
                                  ? Colors.white
                                  : NoRiskClientColors.text),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (activeTab == 0) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: NoRiskTextField(
                  controller: addFriendController,
                  width: MediaQuery.of(context).size.width - 20,
                  hintText: 'add friend by name',
                  fontSize: 35,
                  hasSendButton: true,
                  onSubmitted: (value, _) => addFriend(value),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshCurrentTab,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  children: [
                    if ((activeTab == 0 && isFriendsLoading) ||
                        (activeTab == 1 && isRequestsLoading))
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                            child: LoadingIndicator(height: 32, width: 32)),
                      )
                    else if (activeTab == 0)
                      ...buildFriendsList()
                    else
                      ...buildRequestsList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  List<Widget> buildFriendsList() {
    if (friends.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 35),
          child: NoRiskText('no friends found',
              spaceTop: false,
              spaceBottom: false,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20, color: NoRiskClientColors.text)),
        ),
      ];
    }

    return friends.map((friend) => buildFriendItem(friend)).toList();
  }

  List<Widget> buildRequestsList() {
    if (incomingRequests.isEmpty && outgoingRequests.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 35),
          child: NoRiskText('no pending requests',
              spaceTop: false,
              spaceBottom: false,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20, color: NoRiskClientColors.text)),
        ),
      ];
    }

    return [
      sectionHeader('incoming (${incomingRequests.length})'),
      ...incomingRequests
          .map((request) => buildRequestItem(request, true))
          .toList(),
      const SizedBox(height: 10),
      sectionHeader('outgoing (${outgoingRequests.length})'),
      ...outgoingRequests
          .map((request) => buildRequestItem(request, false))
          .toList(),
    ];
  }

  Widget sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: NoRiskText(
        text,
        spaceTop: false,
        spaceBottom: false,
        style: const TextStyle(
            fontSize: 25,
            color: NoRiskClientColors.text,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildFriendItem(dynamic friend) {
    final Map<String, dynamic> user =
        (friend['noriskUser'] as Map?)?.cast<String, dynamic>() ?? {};
    final String participantId = user['uuid']?.toString() ?? '';
    final String ign = user['ign']?.toString() ?? 'unknown';
    final String onlineState = friend['onlineState']?.toString() ?? 'OFFLINE';

    final Color stateColor = switch (onlineState) {
      'ONLINE' => Colors.green,
      'BUSY' => Colors.orange,
      'INVISIBLE' => Colors.blueGrey,
      _ => Colors.redAccent,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: participantId.isEmpty
            ? null
            : () => openOrCreateChat(participantId),
        child: NoRiskContainer(
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                height: 52,
                width: 52,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: cache['skins']?[participantId] ??
                      const LoadingIndicator(height: 20, width: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NoRiskText(
                      ign.toLowerCase(),
                      spaceTop: false,
                      spaceBottom: false,
                      style: const TextStyle(
                          fontSize: 27.5,
                          color: NoRiskClientColors.text,
                          fontWeight: FontWeight.bold),
                    ),
                    NoRiskText(
                      onlineState.toLowerCase(),
                      spaceTop: false,
                      spaceBottom: false,
                      style: TextStyle(
                          fontSize: (friend['onlineState']?.toString() ??
                                      'OFFLINE') ==
                                  'OFFLINE'
                              ? 18
                              : 25,
                          fontWeight: FontWeight.bold,
                          color: stateColor),
                    ),
                    ...buildLastSeen(friend),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: NoRiskClientColors.text),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildLastSeen(dynamic friend) {
    final String onlineState = friend['onlineState']?.toString() ?? 'OFFLINE';
    if (onlineState != 'OFFLINE') {
      return [];
    }

    final String? rawLastSeen = friend['noriskUser']?['lastSeen']?.toString();
    if (rawLastSeen == null || rawLastSeen.isEmpty) {
      return [];
    }

    final DateTime? parsed = parseBackendDateTime(rawLastSeen);
    if (parsed == null) {
      return [];
    }

    return [
      NoRiskText(
        formatLastSeen(parsed),
        spaceTop: false,
        spaceBottom: false,
        style: const TextStyle(fontSize: 16, color: NoRiskClientColors.text),
      ),
    ];
  }

  DateTime? parseBackendDateTime(String value) {
    final int dotIndex = value.indexOf('.');
    if (dotIndex == -1) {
      return DateTime.tryParse(value)?.toLocal();
    }

    final int timezoneStart = value.indexOf(RegExp(r'[Z+-]'), dotIndex);
    final String fraction = timezoneStart == -1
        ? value.substring(dotIndex + 1)
        : value.substring(dotIndex + 1, timezoneStart);
    final String trimmedFraction =
        fraction.length > 6 ? fraction.substring(0, 6) : fraction;

    final String rebuilt = timezoneStart == -1
        ? '${value.substring(0, dotIndex + 1)}$trimmedFraction'
        : '${value.substring(0, dotIndex + 1)}$trimmedFraction${value.substring(timezoneStart)}';

    return DateTime.tryParse(rebuilt)?.toLocal();
  }

  String formatDateTime(DateTime value) {
    final String day = value.day.toString().padLeft(2, '0');
    final String month = value.month.toString().padLeft(2, '0');
    final String year = value.year.toString();
    final String hour = value.hour.toString().padLeft(2, '0');
    final String minute = value.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $hour:$minute';
  }

  String formatLastSeen(DateTime value) {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(value);

    if (diff.inMinutes < 1) {
      return 'last online just now';
    }
    if (diff.inMinutes < 60) {
      final int minutes = diff.inMinutes;
      return 'last online $minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    }
    if (diff.inHours < 24) {
      final int hours = diff.inHours;
      return 'last online $hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }
    if (diff.inDays == 1) {
      return 'last online yesterday';
    }
    if (diff.inDays < 7) {
      return 'last online ${diff.inDays} days ago';
    }

    return 'last online ${formatDateTime(value)}';
  }

  void showFeedback(String text) {
    Fluttertoast.showToast(msg: text);
  }

  Widget buildRequestItem(dynamic request, bool incoming) {
    final List<dynamic> users = (request['users'] as List?) ?? [];
    final Map<String, dynamic> requestUser =
        users.isNotEmpty ? (users.first as Map).cast<String, dynamic>() : {};
    final String ign = requestUser['ign']?.toString() ?? 'unknown';
    final String uuid = requestUser['uuid']?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: NoRiskContainer(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              height: 42,
              width: 42,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: cache['skins']?[uuid] ??
                    const LoadingIndicator(height: 18, width: 18),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: NoRiskText(
                ign.toLowerCase(),
                spaceTop: false,
                spaceBottom: false,
                style: const TextStyle(
                    fontSize: 21,
                    color: NoRiskClientColors.text,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (incoming)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NoRiskButton(
                    onTap: () => declineFriendRequest(uuid, ign),
                    color: Colors.red.shade700,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 4),
                      child: NoRiskText(
                        'decline',
                        spaceTop: false,
                        spaceBottom: false,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  NoRiskButton(
                    onTap: () => acceptFriendRequest(uuid, ign),
                    color: Colors.green.shade700,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 4),
                      child: NoRiskText(
                        'accept',
                        spaceTop: false,
                        spaceBottom: false,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            else
              NoRiskText(
                'outgoing',
                spaceTop: false,
                spaceBottom: false,
                style: const TextStyle(fontSize: 25, color: Colors.orange),
              )
          ],
        ),
      ),
    );
  }

  Future<void> addFriend(String rawName) async {
    final String name = rawName.trim();
    if (name.isEmpty) return;

    try {
      await NoRiskApi().addFriendByName(name);
      addFriendController.clear();
      if (mounted) {
        showFeedback('friend request sent to $name');
        await refreshCurrentTab();
      }
    } catch (_) {
      if (!mounted) return;
      showFeedback('failed to add friend $name');
    }
  }

  Future<void> acceptFriendRequest(String uuid, String displayName) async {
    if (uuid.isEmpty) return;
    try {
      await NoRiskApi().addFriendByUuid(uuid);
      if (mounted) {
        showFeedback('accepted $displayName');
        await refreshCurrentTab();
      }
    } catch (_) {
      if (!mounted) return;
      showFeedback('failed to accept $displayName');
    }
  }

  Future<void> declineFriendRequest(String uuid, String displayName) async {
    if (uuid.isEmpty) return;
    try {
      await NoRiskApi().removeFriendByUuid(uuid);
      if (mounted) {
        showFeedback('declined $displayName');
        await refreshCurrentTab();
      }
    } catch (_) {
      if (!mounted) return;
      showFeedback('failed to decline $displayName');
    }
  }

  Future<void> loadLanguage() async {
    // Ich schäme mich dafür aber juckt jz grad :skull:
    await Future.delayed(const Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String language = prefs.getString('language') ??
        (Config.availableLanguages
                .contains(PlatformDispatcher.instance.locale.languageCode)
            ? PlatformDispatcher.instance.locale.languageCode
            : Config.fallbackLangauge);
    if (!mounted) return;
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(language);

    if (prefs.getString('language') == null) {
      await prefs.setString('language', language);
    }
  }

  Future<void> loadFriendsPageData() async {
    if (mounted) {
      setState(() {
        isFriendsLoading = true;
        isRequestsLoading = true;
      });
    }

    await loadPrivateChats();
    await loadFriendsData();

    if (!mounted) return;
    setState(() {
      isFriendsLoading = false;
      isRequestsLoading = false;
    });
  }

  Future<void> refreshCurrentTab() async {
    if (activeTab == 0) {
      if (mounted) {
        setState(() {
          isFriendsLoading = true;
        });
      }

      await loadPrivateChats();
      await loadFriendsData(updateFriends: true, updateRequests: false);

      if (!mounted) return;
      setState(() {
        isFriendsLoading = false;
      });
      return;
    }

    if (mounted) {
      setState(() {
        isRequestsLoading = true;
      });
    }

    await loadFriendsData(updateFriends: false, updateRequests: true);

    if (!mounted) return;
    setState(() {
      isRequestsLoading = false;
    });
  }

  Future<void> loadPrivateChats() async {
    final List<dynamic> chatsData = await NoRiskApi().getPrivateChats();
    final Map<String, String> mapped = {};

    for (final chatData in chatsData) {
      final List participants = (chatData['participants'] as List?) ?? [];
      for (final participant in participants) {
        final String userId = participant['userId']?.toString() ?? '';
        if (userId.isEmpty || userId == userData['uuid']) {
          continue;
        }
        final String chatId = chatData['_id']?.toString() ?? '';
        if (chatId.isNotEmpty) {
          mapped[userId] = chatId;
        }
      }
    }

    if (!mounted) return;
    setState(() {
      existingChatsByParticipant = mapped;
    });
  }

  Future<void> loadFriendsData(
      {bool updateFriends = true, bool updateRequests = true}) async {
    final Map<String, dynamic> data = await NoRiskApi().getFriendsByUsername();
    final List<dynamic> loadedFriends = (data['friends'] as List?) ?? [];
    final List<dynamic> pending = (data['pending'] as List?) ?? [];

    for (final friend in loadedFriends) {
      final String uuid = friend['noriskUser']?['uuid']?.toString() ?? '';
      if (uuid.isEmpty) continue;

      getUpdateStream.sink.add([
        'loadSkin',
        uuid,
        () {
          if (mounted) {
            setState(() {
              cache = getCache;
            });
          }
        }
      ]);

      NoRiskApi().getUserProfile(uuid).then((_) {
        if (mounted) {
          setState(() {
            cache = getCache;
          });
        }
      });
    }

    final List<dynamic> incoming = [];
    final List<dynamic> outgoing = [];
    for (final entry in pending) {
      final Map<String, dynamic> friendRequest =
          (entry['friendRequest'] as Map?)?.cast<String, dynamic>() ?? {};
      final Map<String, dynamic> currentState =
          (friendRequest['currentState'] as Map?)?.cast<String, dynamic>() ??
              {};
      final String stateType = currentState['type']?.toString() ?? '';
      if (!stateType.contains('Pending')) {
        continue;
      }

      final String sender = friendRequest['sender']?.toString() ?? '';
      final String receiver = friendRequest['receiver']?.toString() ?? '';

      if (receiver == userData['uuid']) {
        incoming.add(entry);
      } else if (sender == userData['uuid']) {
        outgoing.add(entry);
      }

      final List<dynamic> users = (entry['users'] as List?) ?? [];
      if (users.isNotEmpty) {
        final String requestUuid = users.first['uuid']?.toString() ?? '';
        if (requestUuid.isNotEmpty) {
          getUpdateStream.sink.add(['loadSkin', requestUuid]);
        }
      }
    }

    loadedFriends.sort((a, b) {
      final int stateDiff = onlineStatePriority(a['onlineState']) -
          onlineStatePriority(b['onlineState']);
      if (stateDiff != 0) return stateDiff;

      final String ignA =
          a['noriskUser']?['ign']?.toString().toLowerCase() ?? '';
      final String ignB =
          b['noriskUser']?['ign']?.toString().toLowerCase() ?? '';
      return ignA.compareTo(ignB);
    });

    if (!mounted) return;
    setState(() {
      if (updateFriends) {
        friends = loadedFriends;
      }
      if (updateRequests) {
        incomingRequests = incoming;
        outgoingRequests = outgoing;
      }
    });
  }

  int onlineStatePriority(dynamic state) {
    switch ((state ?? '').toString()) {
      case 'ONLINE':
        return 0;
      case 'BUSY':
        return 1;
      case 'INVISIBLE':
        return 2;
      default:
        return 3;
    }
  }

  Future<void> openOrCreateChat(String participantId) async {
    if (participantId.isEmpty) return;

    final bool isBlocked = await BlockingManager().checkBlocked(participantId);
    if (isBlocked) {
      if (!mounted) return;
      showFeedback('this user is blocked');
      return;
    }

    String? chatId = existingChatsByParticipant[participantId];

    if (chatId == null || chatId.isEmpty) {
      final Map<String, dynamic> response =
          await NoRiskApi().createOrGetPrivateChat(participantId);
      chatId = extractChatId(response);

      if (chatId == null || chatId.isEmpty) {
        await loadPrivateChats();
        chatId = existingChatsByParticipant[participantId];
      }
    }

    if (chatId == null || chatId.isEmpty) {
      if (!mounted) return;
      showFeedback('failed to open chat');
      return;
    }

    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Chat(
        chatId: chatId!,
        participantId: participantId,
        chatUpdateStream: chatUpdateStream,
      ),
    ));
  }

  String? extractChatId(Map<String, dynamic> data) {
    final String? directId = data['_id']?.toString();
    if (directId != null && directId.isNotEmpty) {
      return directId;
    }

    final String? directChatId = data['chatId']?.toString();
    if (directChatId != null && directChatId.isNotEmpty) {
      return directChatId;
    }

    final Map<String, dynamic>? nested =
        (data['chat'] as Map?)?.cast<String, dynamic>();
    final String? nestedId = nested?['_id']?.toString();
    if (nestedId != null && nestedId.isNotEmpty) {
      return nestedId;
    }

    final String? nestedChatId = nested?['chatId']?.toString();
    if (nestedChatId != null && nestedChatId.isNotEmpty) {
      return nestedChatId;
    }

    return null;
  }
}
