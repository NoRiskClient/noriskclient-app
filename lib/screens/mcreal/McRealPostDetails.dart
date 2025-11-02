import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/Colors.dart';
import '../../config/Config.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../utils/NoRiskApi.dart';
import '../../utils/ReportTypes.dart';
import '../../widgets/LoadingIndicator.dart';
import '../../widgets/McRealComment.dart';
import '../../widgets/McRealCommentInput.dart';
import '../../widgets/McRealPost.dart';
import '../../widgets/NoRiskBackButton.dart';
import '../../widgets/NoRiskText.dart';
import '../NoRiskProfile.dart';
import 'ReportMcReal.dart';

class PostDetails extends StatefulWidget {
  const PostDetails({
    super.key,
    required this.postData,
    required this.postUpdateStream,
  });

  final Map<String, dynamic> postData;
  final StreamController<String> postUpdateStream;

  @override
  State<PostDetails> createState() => McRealState();
}

class McRealState extends State<PostDetails> {
  ScrollController scrollController = ScrollController();
  StreamController<String?> commentUpdateStream = StreamController<String?>();
  int page = 0;
  bool hitEnd = false;
  bool isLoadingNewComments = false;
  List<McRealComment>? comments;
  Widget commentInput = Container();
  Map<String, Map<String, dynamic>> cache = getCache;
  Map<String, dynamic> userData = getUserData;

  @override
  void initState() {
    loadComments();
    commentUpdateStream.stream.listen((String? commentId) async {
      if (commentId != null) {
        if (commentId == '*') {
          setState(() {
            comments = null;
            page = 0;
            hitEnd = false;
          });
          loadComments();
          return;
        }
        var res = await http.get(
          Uri.parse(
            '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/post/$commentId?uuid=${userData['uuid']}',
          ),
          headers: {'Authorization': 'Bearer ${userData['token']}'},
        );
        if (res.statusCode != 200) {
          print("Load comment: ${res.statusCode}");
          if (res.statusCode == 401) {
            Navigator.of(context).pop();
            getUpdateStream.sink.add(['signOut']);
          }
          return;
        }
        Map<String, dynamic> commentData = jsonDecode(
          utf8.decode(res.bodyBytes),
        );
        int index = comments!.indexWhere(
          (comment) =>
              comment.commentData['comment']['_id'] ==
              commentData['comment']['_id'],
        );

        if (index == -1) return;

        McRealComment oldComment = comments![index];
        McRealComment newComment = McRealComment(
          parentId: oldComment.parentId,
          commentData: commentData,
          commentUpdateStream: commentUpdateStream,
          postUpdateStream: widget.postUpdateStream,
        );
        setState(() {
          comments![index] = newComment;
        });
      } else {
        setState(() {
          commentInput = commentInput is McRealCommentInput
              ? Container()
              : McRealCommentInput(
                  userData: userData,
                  postId: widget.postData['post']['_id'],
                  refresh: () {
                    setState(() {
                      page = 0;
                      hitEnd = false;
                      commentInput = Container();
                      comments = null;
                    });
                    loadComments();
                  },
                );
        });
      }
    });
    scrollController.addListener(() async {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = 100.0;
      if ((maxScroll - currentScroll <= delta) &&
          isLoadingNewComments != true &&
          hitEnd != true) {
        page++;
        await loadComments();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoRiskClientColors.darkerBackground,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top:
                  MediaQuery.of(context).size.width * 0.85 +
                  (isAndroid ? 50 : 0),
            ),
            child: RefreshIndicator(
              onRefresh: () {
                setState(() {
                  comments = null;
                  page = 0;
                  hitEnd = false;
                });
                return loadComments();
              },
              child: Stack(
                children: [
                  ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: comments != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  commentInput,
                                  if (comments!.isNotEmpty) ...comments!,
                                  if (comments!.isEmpty &&
                                      commentInput is Container)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: NoRiskText(
                                        AppLocalizations.of(
                                          context,
                                        ).mcRealNoComments,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 30,
                                          color: NoRiskClientColors.text,
                                        ),
                                      ),
                                    ),
                                  if ((comments ?? []).length < 5)
                                    const SizedBox(height: 500),
                                  const SizedBox(height: 50),
                                ],
                              )
                            : const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 50),
                                  child: LoadingIndicator(),
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 65,
                  color: NoRiskClientColors.darkerBackground,
                ),
                Container(
                  color: NoRiskClientColors.darkerBackground,
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          NoRiskBackButton(
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      Center(
                        child: NoRiskText(
                          AppLocalizations.of(context).postDetailsTitle,
                          spaceTop: false,
                          spaceBottom: false,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10,
                  color: NoRiskClientColors.darkerBackground,
                ),
                Container(
                  color: NoRiskClientColors.darkerBackground,
                  child: McRealPost(
                    locked: false,
                    postData: widget.postData,
                    postUpdateStream: widget.postUpdateStream,
                    commentUpdateStream: commentUpdateStream,
                    displayOnly: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadComments() async {
    isLoadingNewComments = true;
    http.Response res = await http.get(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments?uuid=${userData['uuid']}&page=$page&postId=${widget.postData['post']['_id']}',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      print(res.statusCode);
      if (res.statusCode == 401) {
        Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      } else if (res.statusCode == 400) {}
      return;
    }
    Map<String, dynamic> commentsData = jsonDecode(utf8.decode(res.bodyBytes));

    if (commentsData['comments'].length < Config.maxCommentsPerPage) {
      hitEnd = true;
      print('Hit end!!!');
    } else {
      hitEnd = false;
    }

    List<McRealComment> newComments = [];
    for (var commentData in commentsData['comments']) {
      newComments.add(
        McRealComment(
          commentData: commentData,
          commentUpdateStream: commentUpdateStream,
          postUpdateStream: widget.postUpdateStream,
        ),
      );
    }

    List<McRealComment> existingPosts = comments ?? [];
    int scrollOffset = scrollController.offset.toInt();

    await Future.delayed(const Duration(milliseconds: 20));
    setState(() {
      comments = [...existingPosts, ...newComments];
    });
    scrollController.jumpTo(scrollOffset.toDouble());
    print(
      'New comments (${newComments.length}): ${newComments.map((c) => c.commentData['comment']['_id'])}',
    );

    isLoadingNewComments = false;
  }

  void openProfilePage(String uuid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            Profile(uuid: uuid, postUpdateStream: widget.postUpdateStream),
      ),
    );
  }

  void openReportPage(String uuid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ReportMcReal(
          type: ReportType.POST,
          contentId: widget.postData['post']['_id'],
        ),
      ),
    );
  }
}
