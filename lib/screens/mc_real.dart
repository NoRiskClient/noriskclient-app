import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/colors.dart';
import '../config/config.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../utils/no_risk_api.dart';
import '../utils/no_risk_icon.dart';
import '../utils/blocking_manager.dart';
import '../widgets/mc_real_post.dart';
import '../widgets/no_risk_icon_button.dart';
import '../widgets/no_risk_text.dart';
import 'profile.dart';

enum McRealStatus {
  ok,
  removed,
  deleted;

  @override
  String toString() => name;
}

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
      }),
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
          '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/post/$data?uuid=${userData['uuid']}',
        ),
        headers: {'Authorization': 'Bearer ${userData['token']}'},
      );
      if (res.statusCode != 200) {
        print("Load player post: ${res.statusCode}");
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
        (post) => post.postData['post']['_id'] == postData['post']['_id'],
      );

      McRealPost oldPost = index == -1 ? ownPost! : posts[index];
      McRealPost newPost = McRealPost(
        locked: oldPost.locked,
        lockedReason: oldPost.lockedReason,
        postData: postData,
        commentUpdateStream: oldPost.commentUpdateStream,
        displayOnly: oldPost.displayOnly,
        postUpdateStream: oldPost.postUpdateStream,
      );
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
                              ? AppLocalizations.of(context).mcRealNoPosts
                              : AppLocalizations.of(context).mcRealNoPostsPlain,
                          spaceTop: false,
                          spaceBottom: false,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            color: NoRiskClientColors.textLight,
                          ),
                        ),
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
                                        icon: NoRiskIcon.reload,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
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
                          // const SizedBox(width: 15),
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
                              AppLocalizations.of(
                                context,
                              ).mcRealFriendsTabLabel,
                              spaceTop: false,
                              spaceBottom: false,
                              style: TextStyle(
                                fontSize: 30,
                                color: NoRiskClientColors.text,
                                fontWeight: activeTab == 0
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          NoRiskText(
                            '|',
                            spaceTop: false,
                            spaceBottom: false,
                            style: TextStyle(
                              fontSize: 30,
                              color: NoRiskClientColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                              AppLocalizations.of(
                                context,
                              ).mcRealDiscoverTabLabel,
                              spaceTop: false,
                              spaceBottom: false,
                              style: TextStyle(
                                fontSize: 30,
                                color: NoRiskClientColors.text,
                                fontWeight: activeTab == 1
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          NoRiskText(
                            '|',
                            spaceTop: false,
                            spaceBottom: false,
                            style: TextStyle(
                              fontSize: 30,
                              color: NoRiskClientColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                              AppLocalizations.of(
                                context,
                              ).mcRealPartnersTabLabel,
                              spaceTop: false,
                              spaceBottom: false,
                              style: TextStyle(
                                fontSize: 30,
                                color: NoRiskClientColors.text,
                                fontWeight: activeTab == 2
                                    ? FontWeight.bold
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 15),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadPlayerPost() async {
    if (userData['mcRealStatus'] != McRealStatus.ok.name) {
      setState(() {
        ownPost = null;
        ownPostData = null;
      });
    }
    userData.remove('mcRealStatus');
    userData.remove('mcRealStatusInfo');
    http.Response res = await http.get(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/post?uuid=${userData['uuid']}',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      print("Load player post: ${res.statusCode}");
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
      if (postData['post']['status'] == McRealStatus.removed) {
        userData['mcRealStatus'] = McRealStatus.removed;
        userData['mcRealStatusInfo'] = postData['post']['statusInfo'];
      } else if (postData['post']['status'] == McRealStatus.deleted) {
        userData['mcRealStatus'] = McRealStatus.deleted;
      }
    }

    setState(() {
      ownPostData = postData;
      ownPost = McRealPost(
        locked: false,
        postData: postData,
        postUpdateStream: postUpdateStream,
      );
    });
  }

  Future<void> loadPosts() async {
    isLoadingNewPosts = true;
    await loadPlayerPost();
    http.Response res = await http.get(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/posts?uuid=${userData['uuid']}&page=$page&friendsOnly=${activeTab == 0}&partnersOnly=${activeTab == 2}',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      print("Load posts: ${res.statusCode}");
      if (res.statusCode == 401) {
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    List postsData = jsonDecode(utf8.decode(res.bodyBytes));

    hitEnd = false;
    if (postsData.length < Config.maxPostsPerPage) hitEnd = true;

    late final String lockedReason;
    if (!mounted) {
      lockedReason = "Unknown error";
    } else if (userData['mcRealStatus'] == McRealStatus.removed) {
      lockedReason = AppLocalizations.of(context).mcRealStatusRemoved;
    } else if (userData['mcRealStatus'] == McRealStatus.deleted) {
      lockedReason = AppLocalizations.of(context).mcRealStatusDeleted;
    } else if (ownPost == null) {
      lockedReason = AppLocalizations.of(context).mcRealStatusNoPost;
    }

    List<McRealPost> newPosts = [];
    for (var postData in postsData) {
      bool isBlocked = await BlockingManager().checkBlocked(
        postData['post']['author'],
      );
      if (isBlocked) continue;

      newPosts.add(
        McRealPost(
          locked: ownPost == null || lockedReason != '',
          lockedReason: lockedReason,
          postData: postData,
          postUpdateStream: postUpdateStream,
        ),
      );
    }

    List<McRealPost> existingPosts = posts;
    int scrollOffset = scrollController.offset.toInt();

    await Future.delayed(const Duration(milliseconds: 10));
    setState(() {
      posts = [...existingPosts, ...newPosts];
    });
    scrollController.jumpTo(scrollOffset.toDouble());
    print('New posts: ${posts.map((p) => p.postData['post']['_id'])}');

    isLoadingNewPosts = false;
  }

  void openProfilePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Profile(
          uuid: userData['uuid'],
          isSettings: true,
          postUpdateStream: postUpdateStream,
        ),
      ),
    );
  }
}
