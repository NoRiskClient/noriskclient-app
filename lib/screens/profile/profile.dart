import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/screens/settings/settings.dart';
import 'package:noriskclient/services/blocking_manager.dart';
import 'package:noriskclient/services/api_client.dart';
import 'package:noriskclient/utils/nr_icons.dart';
import 'package:noriskclient/widgets/common/nr_back_button.dart';
import 'package:noriskclient/widgets/common/nr_container.dart';
import 'package:noriskclient/widgets/profile/profile_stat_container.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';
import 'package:noriskclient/widgets/profile/profile_mcreal_post.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
    required this.uuid,
    this.isSettings = false,
    this.postUpdateStream,
  });

  final String uuid;
  final bool isSettings;
  final StreamController<String>? postUpdateStream;

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  List<ProfileMcRealPost>? pinns;
  StreamController<List> profilePostsUpdateStream = StreamController<List>();
  Map<String, Map<String, dynamic>> cache = getCache;
  Map<String, dynamic> userData = getUserData;
  bool noPinns = true;
  bool? blocked;

  bool PSJahn = false;
  bool Aim_shock = false;

  @override
  void initState() {
    super.initState();
    loadPinnedPosts(null, null);
    loadBlockedState();
    getUpdateStream.sink.add([
      'loadUsername',
      widget.uuid,
      () => setState(() {
        cache = getCache;
      }),
    ]);
  }

  void toggleEasteregg() {
    if (widget.uuid == '1245c340-8bdb-4796-838e-a247f1594796') {
      setState(() => PSJahn = !PSJahn);
    } else if (widget.uuid == '625dd22b-bad2-4b82-a0bc-e43ba1c1a7fd') {
      setState(() => Aim_shock = !Aim_shock);
      if (Aim_shock) {
        showDialog(
          context: context,
          builder: isAndroid
              ? (context) => AlertDialog(
                  title: const Text('Tea Time 🍵'),
                  content: const Text(
                    'Welcome to the Tea Time!\nCome have a seat and calm down with a cup of tea 😊',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Close',
                        style: TextStyle(color: NoRiskClientColors.blue),
                      ),
                    ),
                  ],
                )
              : (context) => CupertinoAlertDialog(
                  title: const Text('Tea Time 🍵'),
                  content: const Text(
                    'Welcome to the Tea Time!\nCome have a seat and calm down with a cup of tea 😊',
                  ),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double hPad = 15;
    final double statGap = 10;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: NoRiskClientColors.background,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: PSJahn
              ? DecorationImage(
                  image: Image.asset(
                    'lib/assets/app/gommehd.png',
                    repeat: ImageRepeat.repeat,
                  ).image,
                  repeat: ImageRepeat.repeat,
                )
              : null,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 10),
                _buildAvatar(),
                const SizedBox(height: 12),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => loadPinnedPosts(null, null),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 80),
                      children: [
                        Row(
                          children: [
                            NoRiskProfileStatisticContainer(
                              width: (screenWidth - 2 * hPad - statGap) / 2,
                              title: AppLocalizations.of(
                                context,
                              )!.profile_stats_firstJoin,
                              value: _formatTimestamp(
                                cache['profiles']?[widget
                                    .uuid]?['firstJoinTimeStamp'],
                              ),
                            ),
                            SizedBox(width: statGap),
                            NoRiskProfileStatisticContainer(
                              width: (screenWidth - 2 * hPad - statGap) / 2,
                              title: AppLocalizations.of(
                                context,
                              )!.profile_stats_lastJoin,
                              value: _formatTimestamp(
                                cache['profiles']?[widget
                                    .uuid]?['lastJoinTimeStamp'],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: statGap),
                        Row(
                          children: [
                            NoRiskProfileStatisticContainer(
                              width: (screenWidth - 2 * hPad - 2 * statGap) / 3,
                              title: AppLocalizations.of(
                                context,
                              )!.profile_stats_loginStreak,
                              value:
                                  cache['profiles']?[widget
                                          .uuid]?['nrcUser']?['loginStreak']?['days']
                                      ?.toString() ??
                                  '?',
                            ),
                            SizedBox(width: statGap),
                            NoRiskProfileStatisticContainer(
                              width: (screenWidth - 2 * hPad - 2 * statGap) / 3,
                              title: AppLocalizations.of(
                                context,
                              )!.profile_stats_mcReal,
                              value:
                                  cache['profiles']?[widget
                                          .uuid]?['mcRealStreak']?['days']
                                      ?.toString() ??
                                  '?',
                            ),
                            SizedBox(width: statGap),
                            NoRiskProfileStatisticContainer(
                              width: (screenWidth - 2 * hPad - 2 * statGap) / 3,
                              title: AppLocalizations.of(
                                context,
                              )!.profile_stats_playtime,
                              value: _formatPlaytime(
                                cache['profiles']?[widget.uuid]?['playTime'],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        if (!noPinns && blocked != true) ...[
                          ...pinns!,
                          const SizedBox(height: 50),
                        ],
                        if (noPinns || blocked == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Center(
                              child: NoRiskText(
                                blocked == true
                                    ? AppLocalizations.of(
                                        context,
                                      )!.mcReal_profile_blockedPlayer
                                    : '${cache['usernames']?[widget.uuid] ?? 'Unknown'}${AppLocalizations.of(context)!.profile_noPinnedPosts}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!widget.isSettings)
          NoRiskBackButton(onPressed: () => Navigator.of(context).pop())
        else
          const SizedBox(width: 32),
        Expanded(
          child: Column(
            children: [
              NoRiskText(
                (widget.uuid == userData['uuid']
                        ? AppLocalizations.of(context)!.profile_yourProfile
                        : (cache['usernames']?[widget.uuid] ?? 'Unknown'))
                    .toString(),
                spaceTop: false,
                spaceBottom: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: NoRiskClientColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (cache['profiles']?[widget.uuid] != null &&
                  cache['profiles']![widget
                          .uuid]['nrcUser']['noRiskPlusExpirationDate'] !=
                      null &&
                  cache['profiles']![widget
                          .uuid]['nrcUser']['noRiskPlusExpirationDate'] >
                      0 &&
                  cache['profiles']![widget
                      .uuid]['nrcUser']['additionalNameTag']['isEnabled'])
                NoRiskText(
                  (cache['profiles']![widget
                              .uuid]['nrcUser']['additionalNameTag']['text'] ??
                          'Unknown')
                      .replaceAll(
                        RegExp(r'[§&][0-9A-FK-OR]', caseSensitive: false),
                        '',
                      ),
                  maxLength:
                      MediaQuery.of(context).size.width -
                      2 * 15 -
                      2 * 30 -
                      2 * 15,
                  spaceTop: false,
                  spaceBottom: false,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: NoRiskClientColors.blue,
                  ),
                ),
            ],
          ),
        ),
        if (blocked != null)
          NoRiskContainer(
            child: GestureDetector(
              onTap: blocked! ? unblock : block,
              onLongPress: () => Fluttertoast.showToast(
                msg:
                    '${blocked == false ? 'Block' : 'Unblock'} ${cache['usernames']?[widget.uuid] ?? 'Unknown'}',
              ),
              child: SizedBox(
                height: 26.5,
                width: 26.5,
                child: Center(
                  child: Icon(
                    blocked == false ? Icons.block : Icons.handshake,
                    color: blocked == false ? Colors.red : Colors.green,
                    size: 20,
                  ),
                ),
              ),
            ),
          )
        else if (widget.isSettings)
          GestureDetector(
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => Settings())),
            child: NoRiskContainer(
              child: SizedBox(
                height: 32,
                width: 32,
                child: Center(
                  child: NRIcons.svg(
                    'settings',
                    color: NoRiskClientColors.text,
                    size: 18,
                  ),
                ),
              ),
            ),
          )
        else
          const SizedBox(width: 32),
      ],
    );
  }

  Widget _buildAvatar() {
    final skin = cache['armorSkins']?[widget.uuid];
    if (skin == null) return const SizedBox.shrink();
    return Center(
      child: GestureDetector(onTap: toggleEasteregg, child: skin),
    );
  }

  String _formatTimestamp(dynamic ms) {
    if (ms == null) return '?';
    return DateTime.fromMillisecondsSinceEpoch(ms as int)
        .toIso8601String()
        .split('T')[0]
        .replaceAll('-', '.')
        .split('.')
        .reversed
        .join('.');
  }

  String _formatPlaytime(dynamic ms) {
    if (ms == null) return '?';
    final duration = Duration(milliseconds: ms as int);
    return duration.inDays > 0 ? '${duration.inDays}d' : '${duration.inHours}h';
  }

  void loadBlockedState() {
    if (widget.uuid == userData['uuid']) return;
    BlockingManager().checkBlocked(widget.uuid).then((bool val) {
      setState(() => blocked = val);
    });
  }

  void block() {
    showDialog(
      context: context,
      builder: (context) => Platform.isAndroid
          ? AlertDialog(
              title: Text(
                AppLocalizations.of(
                  context,
                )!.mcReal_profile_blockUserPopupTitle,
              ),
              content: Text(
                AppLocalizations.of(
                  context,
                )!.mcReal_profile_blockUserPopupContent,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.mcReal_popup_cancel,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await BlockingManager().block(widget.uuid);
                    loadBlockedState();
                    widget.postUpdateStream?.sink.add('*');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.mcReal_popup_yes,
                    style: TextStyle(color: NoRiskClientColors.blue),
                  ),
                ),
              ],
            )
          : CupertinoAlertDialog(
              title: Text(
                AppLocalizations.of(
                  context,
                )!.mcReal_profile_blockUserPopupTitle,
              ),
              content: Text(
                AppLocalizations.of(
                  context,
                )!.mcReal_profile_blockUserPopupContent,
              ),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.mcReal_popup_cancel,
                  ),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    await BlockingManager().block(widget.uuid);
                    loadBlockedState();
                    widget.postUpdateStream?.sink.add('*');
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.mcReal_popup_yes),
                ),
              ],
            ),
    );
  }

  void unblock() {
    showDialog(
      context: context,
      builder: (context) => Platform.isAndroid
          ? AlertDialog(
              title: Text(
                AppLocalizations.of(
                  context,
                )!.mcReal_profile_unblockUserPopupTitle,
              ),
              content: Text(
                AppLocalizations.of(
                  context,
                )!.mcReal_profile_unblockUserPopupContent,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.mcReal_popup_cancel,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await BlockingManager().unblock(widget.uuid);
                    loadBlockedState();
                    widget.postUpdateStream?.sink.add('*');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.mcReal_popup_yes,
                    style: TextStyle(color: NoRiskClientColors.blue),
                  ),
                ),
              ],
            )
          : CupertinoAlertDialog(
              title: Text(
                AppLocalizations.of(
                  context,
                )!.mcReal_profile_unblockUserPopupTitle,
              ),
              content: Text(
                AppLocalizations.of(
                  context,
                )!.mcReal_profile_unblockUserPopupContent,
              ),
              actions: [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.mcReal_popup_cancel,
                  ),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    await BlockingManager().unblock(widget.uuid);
                    loadBlockedState();
                    widget.postUpdateStream?.sink.add('*');
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.mcReal_popup_yes),
                ),
              ],
            ),
    );
  }

  Future<void> loadPinnedPosts(
    int? refreshPostIndex,
    void Function(Map<String, dynamic>? newData)? updateData,
  ) async {
    if (refreshPostIndex == null) {
      setState(() {
        pinns = null;
        noPinns = true;
      });
    }

    await NoRiskApi().getUserProfile(widget.uuid);
    setState(() => cache = getCache);

    final List<ProfileMcRealPost> newPinnedPosts = [];
    int index = 0;
    for (final pinnedPost
        in cache['profiles']?[widget.uuid]?['pinnedPosts'] ?? []) {
      newPinnedPosts.add(
        ProfileMcRealPost(
          postData: pinnedPost,
          profilePostIndex: index,
          profileUuid: widget.uuid,
          profilePostsUpdateStream: profilePostsUpdateStream,
        ),
      );
      if (pinnedPost != null) setState(() => noPinns = false);
      index++;
    }

    if (refreshPostIndex != null) {
      setState(() {
        pinns![refreshPostIndex] = newPinnedPosts[refreshPostIndex];
      });
      updateData!(pinns![refreshPostIndex].postData);
    } else {
      setState(() => pinns = newPinnedPosts);
    }
  }
}
