import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/config/config.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/screens/profile/profile.dart';
import 'package:noriskclient/screens/mcreal/report_mc_real.dart';
import 'package:noriskclient/services/api_client.dart';
import 'package:noriskclient/models/report_types.dart';
import 'package:noriskclient/widgets/common/loading_indicator.dart';
import 'package:noriskclient/widgets/feed/mcreal_comment.dart';
import 'package:noriskclient/widgets/feed/mcreal_comment_input.dart';
import 'package:noriskclient/widgets/feed/mcreal_post.dart';
import 'package:noriskclient/widgets/common/nr_back_button.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

class PostDetails extends StatefulWidget {
  const PostDetails(
      {super.key, required this.postData, required this.postUpdateStream});

  final Map<String, dynamic> postData;
  final StreamController<String> postUpdateStream;

  @override
  State<PostDetails> createState() => PostDetailsState();
}

class PostDetailsState extends State<PostDetails> {
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
                '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/post/$commentId?uuid=${userData['uuid']}'),
            headers: {'Authorization': 'Bearer ${userData['token']}'});
        if (res.statusCode != 200) {
          if (res.statusCode == 401) {
            Navigator.of(context).pop();
            getUpdateStream.sink.add(['signOut']);
          }
          return;
        }
        Map<String, dynamic> commentData =
            jsonDecode(utf8.decode(res.bodyBytes));
        int index = comments!.indexWhere((comment) =>
            comment.commentData['comment']['_id'] ==
            commentData['comment']['_id']);

        if (index == -1) return;

        McRealComment oldComment = comments![index];
        McRealComment newComment = McRealComment(
            parentId: oldComment.parentId,
            commentData: commentData,
            commentUpdateStream: commentUpdateStream,
            postUpdateStream: widget.postUpdateStream);
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
                  });
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
        backgroundColor: NoRiskClientColors.background,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.85 +
                      (isAndroid ? 50 : 0)),
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
                                          padding:
                                              const EdgeInsets.only(top: 50),
                                          child: NoRiskText(
                                              AppLocalizations.of(context)!
                                                  .mcReal_noComments,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color:
                                                      NoRiskClientColors.text)),
                                        ),
                                      if ((comments ?? []).length < 5)
                                        const SizedBox(height: 500),
                                      const SizedBox(height: 50)
                                    ])
                              : const Center(
                                  child: Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: LoadingIndicator()),
                                ),
                        )
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
                        height: 65, color: NoRiskClientColors.background),
                    Container(
                      color: NoRiskClientColors.background,
                      child: Stack(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              NoRiskBackButton(
                                  onPressed: () => Navigator.of(context).pop())
                            ]),
                        Center(
                          child: NoRiskText(
                              AppLocalizations.of(context)!.postDetails_title,
                              spaceTop: false,
                              spaceBottom: false,
                              style: TextStyle(
                                  color: NoRiskClientColors.text,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        )
                      ]),
                    ),
                    Container(
                        height: 10, color: NoRiskClientColors.background),
                    Container(
                      color: NoRiskClientColors.background,
                      child: McRealPost(
                          locked: false,
                          postData: widget.postData,
                          postUpdateStream: widget.postUpdateStream,
                          commentUpdateStream: commentUpdateStream,
                          displayOnly: true),
                    ),
                  ]),
            )
          ],
        ));
  }

  Future<void> loadComments() async {
    isLoadingNewComments = true;
    http.Response res = await http.get(
        Uri.parse(
            '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments?uuid=${userData['uuid']}&page=$page&postId=${widget.postData['post']['_id']}'),
        headers: {'Authorization': 'Bearer ${userData['token']}'});
    if (res.statusCode != 200) {
      if (res.statusCode == 401) {
        Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      isLoadingNewComments = false;
      return;
    }
    Map<String, dynamic> commentsData = jsonDecode(utf8.decode(res.bodyBytes));

    if (commentsData['comments'].length < Config.maxCommentsPerPage) {
      hitEnd = true;
    } else {
      hitEnd = false;
    }

    List<McRealComment> newComments = [];
    for (var commentData in commentsData['comments']) {
      newComments.add(McRealComment(
          commentData: commentData,
          commentUpdateStream: commentUpdateStream,
          postUpdateStream: widget.postUpdateStream));
    }

    List<McRealComment> existingPosts = comments ?? [];
    int scrollOffset = scrollController.offset.toInt();

    setState(() {
      comments = [...existingPosts, ...newComments];
    });
    scrollController.jumpTo(scrollOffset.toDouble());

    isLoadingNewComments = false;
  }

  void openProfilePage(String uuid) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            Profile(uuid: uuid, postUpdateStream: widget.postUpdateStream)));
  }

  void openReportPage(String uuid) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ReportMcReal(
            type: ReportType.POST, contentId: widget.postData['post']['_id'])));
  }
}
