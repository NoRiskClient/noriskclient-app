import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/config/config.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/screens/profile/profile.dart';
import 'package:noriskclient/services/blocking_manager.dart';
import 'package:noriskclient/models/mcreal_status.dart';
import 'package:noriskclient/services/api_client.dart';
import 'package:noriskclient/utils/nr_icons.dart';
import 'package:noriskclient/widgets/feed/mcreal_post.dart';
import 'package:noriskclient/widgets/common/nr_icon_button.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

Map<String, dynamic>? ownPostData;

class McReal extends StatefulWidget {
  const McReal({super.key});

  @override
  State<McReal> createState() => McRealState();
}

class McRealState extends State<McReal> {
  ScrollController scrollController = ScrollController();
  StreamController<String> postUpdateStream = StreamController<String>();
  int activeTab = 0;
  int page = 0;
  bool hitEnd = false;
  bool isLoadingNewPosts = false;
  McRealPost? ownPost;
  List<McRealPost> posts = [];

  @override
  void initState() {
    getUpdateStream.sink.add([
      'loadSkin',
      userData['uuid'],
      () => setState(() {
            cache = getCache;
          })
    ]);
    loadPosts();
    postUpdateStream.stream.listen((String data) async {
      if (data == '*') {
        setState(() {
          ownPost = null;
          posts = [];
          page = 0;
        });
        loadPosts();
        return;
      }
      var res = await http.get(
          Uri.parse(
              '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/post/$data?uuid=${userData['uuid']}'),
          headers: {'Authorization': 'Bearer ${userData['token']}'});
      if (res.statusCode != 200) {
        if (res.statusCode == 403) {
          setState(() {
            ownPost = null;
          });
        } else if (res.statusCode == 401) {
          getUpdateStream.sink.add(['signOut']);
        }
        return;
      }
      Map<String, dynamic> postData = jsonDecode(utf8.decode(res.bodyBytes));
      int index = posts.indexWhere(
          (post) => post.postData['post']['_id'] == postData['post']['_id']);

      McRealPost oldPost = index == -1 ? ownPost! : posts[index];
      McRealPost newPost = McRealPost(
          locked: oldPost.locked,
          lockedReason: oldPost.lockedReason,
          postData: postData,
          commentUpdateStream: oldPost.commentUpdateStream,
          displayOnly: oldPost.displayOnly,
          postUpdateStream: oldPost.postUpdateStream);
      setState(() {
        if (index == -1) {
          ownPost = newPost;
        } else {
          posts[index] = newPost;
        }
      });
    });

    scrollController.addListener(() async {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = 100.0;
      if ((maxScroll - currentScroll <= delta) &&
          isLoadingNewPosts != true &&
          hitEnd != true) {
        page++;
        await loadPosts();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    postUpdateStream.close();
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
              ownPost = null;
              ownPostData = null;
              posts = [];
              page = 0;
            });
            loadPlayerPost();
            loadPosts();
          },
          child: Stack(
            children: [
              ListView(
                controller: scrollController,
                children: [
                  SizedBox(height: Platform.isAndroid ? 60 : 35),
                  posts.isEmpty && ownPost == null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 35),
                          child: NoRiskText(
                              userData['mcRealStatus'] == null
                                  ? AppLocalizations.of(context)!.mcReal_noPosts
                                  : AppLocalizations.of(context)!
                                      .mcReal_noPostsPlain,
                              spaceTop: false,
                              spaceBottom: false,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: NoRiskClientColors.textLight)),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                if (activeTab != 2 && ownPost != null) ownPost!,
                                ...posts,
                                (ownPost != null ? 1 : 0) + posts.length <= 2
                                    ? SizedBox(
                                        height: 30,
                                        child: Center(
                                            child: NoRiskIconButton(
                                                onTap: () {
                                                  setState(() {
                                                    posts = [];
                                                    page = 0;
                                                  });
                                                  loadPosts();
                                                },
                                                transparent: true,
                                                icon: NoRiskIcon.reload)))
                                    : Container()
                              ]),
                        ),
                  const SizedBox(height: 80),
                ],
              ),
              ClipRRect(
                child: SizedBox(
                  height: 100,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: Platform.isAndroid ? 45 : 55),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (activeTab == 0) return;
                                  setState(() {
                                    activeTab = 0;
                                    posts = [];
                                    page = 0;
                                  });
                                  loadPosts();
                                },
                                child: NoRiskText(
                                    AppLocalizations.of(context)!
                                        .mcReal_friendsOnly,
                                    spaceTop: false,
                                    spaceBottom: false,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: activeTab == 0
                                            ? NoRiskClientColors.blue
                                            : NoRiskClientColors.text,
                                        fontWeight: activeTab == 0
                                            ? FontWeight.bold
                                            : FontWeight.w400)),
                              ),
                              NoRiskText('|',
                                  spaceTop: false,
                                  spaceBottom: false,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: NoRiskClientColors.textLight,
                                      fontWeight: FontWeight.w300)),
                              GestureDetector(
                                onTap: () {
                                  if (activeTab == 1) return;
                                  setState(() {
                                    activeTab = 1;
                                    posts = [];
                                    page = 0;
                                  });
                                  loadPosts();
                                },
                                child: NoRiskText(
                                    AppLocalizations.of(context)!
                                        .mcReal_discovery,
                                    spaceTop: false,
                                    spaceBottom: false,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: activeTab == 1
                                            ? NoRiskClientColors.blue
                                            : NoRiskClientColors.text,
                                        fontWeight: activeTab == 1
                                            ? FontWeight.bold
                                            : FontWeight.w400)),
                              ),
                              NoRiskText('|',
                                  spaceTop: false,
                                  spaceBottom: false,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: NoRiskClientColors.textLight,
                                      fontWeight: FontWeight.w300)),
                              GestureDetector(
                                onTap: () {
                                  if (activeTab == 2) return;
                                  setState(() {
                                    activeTab = 2;
                                    posts = [];
                                    page = 0;
                                  });
                                  loadPosts();
                                },
                                child: NoRiskText(
                                    AppLocalizations.of(context)!
                                        .mcReal_partnerPosts,
                                    spaceTop: false,
                                    spaceBottom: false,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: activeTab == 2
                                            ? NoRiskClientColors.blue
                                            : NoRiskClientColors.text,
                                        fontWeight: activeTab == 2
                                            ? FontWeight.bold
                                            : FontWeight.w400)),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> loadPlayerPost() async {
    if (userData['mcRealStatus'] != McRealStatus.OK) {
      setState(() {
        ownPost = null;
        ownPostData = null;
      });
    }
    userData.remove('mcRealStatus');
    userData.remove('mcRealStatusInfo');
    http.Response res = await http.get(
        Uri.parse(
            '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/post?uuid=${userData['uuid']}'),
        headers: {'Authorization': 'Bearer ${userData['token']}'});
    if (res.statusCode != 200) {
      if (res.statusCode == 403) {
        setState(() {
          ownPost = null;
        });
      } else if (res.statusCode == 401) {
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    Map<String, dynamic> postData = jsonDecode(utf8.decode(res.bodyBytes));

    if (postData['post']['status'] != null) {
      if (postData['post']['status'] == McRealStatus.REMOVED) {
        userData['mcRealStatus'] = McRealStatus.REMOVED;
        userData['mcRealStatusInfo'] = postData['post']['statusInfo'];
      } else if (postData['post']['status'] == McRealStatus.DELETED) {
        userData['mcRealStatus'] = McRealStatus.DELETED;
      }
    }

    setState(() {
      ownPostData = postData;
      ownPost = McRealPost(
          locked: false,
          postData: postData,
          postUpdateStream: postUpdateStream);
    });
  }

  Future<void> loadPosts() async {
    isLoadingNewPosts = true;
    if (page == 0) {
      await loadPlayerPost();
    }
    http.Response res = await http.get(
        Uri.parse(
            '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/posts?uuid=${userData['uuid']}&page=$page&friendsOnly=${activeTab == 0}&partnersOnly=${activeTab == 2}'),
        headers: {'Authorization': 'Bearer ${userData['token']}'});
    if (res.statusCode != 200) {
      isLoadingNewPosts = false;
      if (res.statusCode == 401) {
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    List postsData = jsonDecode(utf8.decode(res.bodyBytes));

    if (postsData.length < Config.maxPostsPerPage) {
      hitEnd = true;
    } else {
      hitEnd = false;
    }

    String lockedReason = '';
    if (userData['mcRealStatus'] == McRealStatus.REMOVED) {
      lockedReason = AppLocalizations.of(context)!.mcReal_status_removed;
    } else if (userData['mcRealStatus'] == McRealStatus.DELETED) {
      lockedReason = AppLocalizations.of(context)!.mcReal_status_deleted;
    } else if (ownPost == null) {
      lockedReason = AppLocalizations.of(context)!.mcReal_status_noPost;
    }

    List<McRealPost> newPosts = [];
    for (var postData in postsData) {
      bool isBlocked =
          await BlockingManager().checkBlocked(postData['post']['author']);
      if (isBlocked) continue;

      newPosts.add(McRealPost(
          locked: ownPost == null || lockedReason != '',
          lockedReason: lockedReason,
          postData: postData,
          postUpdateStream: postUpdateStream));
    }

    List<McRealPost> existingPosts = posts;
    int scrollOffset = scrollController.offset.toInt();

    setState(() {
      posts = [...existingPosts, ...newPosts];
    });
    scrollController.jumpTo(scrollOffset.toDouble());

    isLoadingNewPosts = false;
  }

  void openProfilePage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => Profile(
            uuid: userData['uuid'],
            isSettings: true,
            postUpdateStream: postUpdateStream)));
  }
}
