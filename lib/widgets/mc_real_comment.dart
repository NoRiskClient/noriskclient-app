import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/colors.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../screens/mcreal/report.dart';
import '../screens/profile.dart';
import '../utils/no_risk_api.dart';
import '../utils/no_risk_icon.dart';
import '../utils/report_types.dart';
import 'mc_real_comment_input.dart';
import 'no_risk_button.dart';
import 'no_risk_container.dart';
import 'no_risk_icon_button.dart';
import 'no_risk_loading_indicator.dart';
import 'no_risk_text.dart';

class McRealComment extends StatefulWidget {
  const McRealComment({
    super.key,
    required this.commentData,
    required this.commentUpdateStream,
    required this.postUpdateStream,
    this.parentId = '',
  });

  final Map<String, dynamic> commentData;
  final StreamController<String?> commentUpdateStream;
  final StreamController<String> postUpdateStream;
  final String parentId;

  @override
  State<McRealComment> createState() => McRealPostState();
}

class McRealPostState extends State<McRealComment> {
  int page = 0;
  bool ownComment = false;
  int likes = 0;
  int dislikes = 0;
  bool? ownRating;
  List<McRealComment> replies = [];
  bool showReplies = false;
  bool deleted = false;
  bool currentlyUpdatingVotes = false;
  Widget commentInput = Container();
  Map<String, Map<String, dynamic>> cache = getCache;
  Map<String, dynamic> userData = getUserData;

  @override
  void initState() {
    getUpdateStream.sink.add([
      'loadSkin',
      widget.commentData['comment']['author'],
      () {
        cache = getCache;
        if (mounted) setState(() {});
      },
    ]);
    ownComment = userData['uuid'] == widget.commentData['comment']['author'];
    if (!ownComment) {
      getUpdateStream.sink.add([
        'loadUsername',
        widget.commentData['comment']['author'],
        () {
          cache = getCache;
          if (mounted) setState(() {});
        },
      ]);
    }
    likes = widget.commentData['likes'];
    dislikes = widget.commentData['dislikes'];
    if (widget.commentData['userRating'] != null) {
      ownRating = widget.commentData['userRating']?['isPositive'];
    }
    loadReplies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return deleted
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: NoRiskContainer(
              padding: const EdgeInsets.all(7.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: openProfilePage,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2.5),
                          child:
                              cache['skins']?[widget
                                  .commentData['comment']['author']] ??
                              const SizedBox(
                                height: 32,
                                width: 32,
                                child: NoRiskLoadingIndicator(),
                              ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        height: 40,
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NoRiskText(
                                  ownComment
                                      ? AppLocalizations.of(
                                          context,
                                        ).mcRealCommentYou
                                      : cache['usernames']?[widget
                                                    .commentData['comment']['author']]
                                                .toString()
                                                .toLowerCase() ??
                                            '',
                                  spaceTop: false,
                                  spaceBottom: false,
                                  style: TextStyle(
                                    fontSize: 27.5,
                                    fontWeight: FontWeight.bold,
                                    color: ownComment
                                        ? NoRiskClientColors.blue
                                        : Colors.white,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                NoRiskText(
                                  widget.commentData['comment']['time']
                                      .toString()
                                      .split('.')[0]
                                      .toLowerCase(),
                                  spaceTop: false,
                                  spaceBottom: false,
                                  style: const TextStyle(
                                    fontSize: 27.5,
                                    fontWeight: FontWeight.w500,
                                    color: NoRiskClientColors.light,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  NoRiskText(
                    widget.commentData['comment']['text']
                        .toString()
                        .toLowerCase(),
                    spaceTop: false,
                    spaceBottom: false,
                    style: const TextStyle(
                      fontSize: 27.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      if (likes - dislikes != 0)
                        Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: NoRiskText(
                            (likes - dislikes).toString(),
                            spaceTop: false,
                            spaceBottom: false,
                            style: TextStyle(
                              fontSize: 35,
                              color: likes - dislikes > 0
                                  ? Colors.green
                                  : likes - dislikes < 0
                                  ? Colors.red
                                  : NoRiskClientColors.text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (likes - dislikes != 0) const SizedBox(width: 5),
                      NoRiskButton(
                        onTap: ownRating == true ? deleteRating : upvote,
                        height: 30,
                        color: ownRating == true
                            ? Colors.green
                            : NoRiskClientColors.text,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.5),
                          child: NoRiskText(
                            "like",
                            spaceTop: false,
                            spaceBottom: false,
                            style: TextStyle(
                              fontSize: 20,
                              color: NoRiskClientColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      NoRiskButton(
                        onTap: ownRating == false ? deleteRating : downvote,
                        height: 30,
                        color: ownRating == false
                            ? Colors.red
                            : NoRiskClientColors.text,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.5),
                          child: NoRiskText(
                            "dislike",
                            spaceTop: false,
                            spaceBottom: false,
                            style: TextStyle(
                              fontSize: 20,
                              color: NoRiskClientColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      NoRiskIconButton(onTap: reply, icon: NoRiskIcon.comment),
                      if (!ownComment) const SizedBox(width: 10),
                      if (!ownComment)
                        NoRiskIconButton(
                          onTap: report,
                          icon: NoRiskIcon.report,
                        ),
                      const SizedBox(width: 7.5),
                      if (ownComment)
                        NoRiskIconButton(
                          onTap: delete,
                          icon: NoRiskIcon.delete,
                        ),
                    ],
                  ),
                  SizedBox(
                    height: replies.isNotEmpty && commentInput is Container
                        ? 5
                        : 0,
                  ),
                  commentInput,
                  if (replies.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        showReplies = !showReplies;
                        if (mounted) setState(() {});
                      },
                      child: SizedBox(
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 7.5),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                child: RotatedBox(
                                  quarterTurns: showReplies ? 1 : 0,
                                  child: Image.asset(
                                    'lib/assets/icons/arrow.png',
                                    height: 12.5,
                                    width: 12.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 7.5),
                            NoRiskText(
                              '${replies.length} ${replies.length > 1 ? AppLocalizations.of(context).mcRealCommentReplies : AppLocalizations.of(context).mcRealCommentReply}'
                                  .toLowerCase(),
                              spaceTop: false,
                              spaceBottom: true,
                              style: const TextStyle(
                                fontSize: 30,
                                color: NoRiskClientColors.text,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (showReplies)
                    Padding(
                      padding: EdgeInsets.only(
                        left: widget.parentId.isEmpty ? 15 : 0,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 7.5),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Column(children: replies),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
  }

  Future<void> loadReplies() async {
    http.Response res = await http.get(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments?uuid=${userData['uuid']}&page=$page&postId=${widget.commentData['comment']['postId']}&parentCommentId=${widget.commentData['comment']['_id']}',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      if (res.statusCode == 401) {
        if (mounted) Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    Map<String, dynamic> commentsData = jsonDecode(utf8.decode(res.bodyBytes));

    List<McRealComment> newReplies = [];
    for (var commentData in commentsData['comments']) {
      newReplies.add(
        McRealComment(
          commentData: commentData,
          commentUpdateStream: widget.commentUpdateStream,
          parentId: widget.commentData['comment']['_id'],
          postUpdateStream: widget.postUpdateStream,
        ),
      );
    }

    replies = newReplies;
    if (mounted) setState(() {});
  }

  void openProfilePage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Profile(
          uuid: widget.commentData['comment']['author'],
          postUpdateStream: widget.postUpdateStream,
        ),
      ),
    );
  }

  Future<void> reply() async {
    commentInput = commentInput is McRealCommentInput
        ? Container()
        : McRealCommentInput(
            userData: userData,
            postId: widget.commentData['comment']['postId'],
            parentCommentId: widget.commentData['comment']['_id'],
            refresh: () => widget.commentUpdateStream.sink.add("*"),
          );
    if (mounted) setState(() {});
  }

  Future<void> upvote() async {
    if (currentlyUpdatingVotes) return;
    int oldLikes = likes;
    int oldDislikes = dislikes;
    bool? oldOwnRating = ownRating;

    likes++;
    if (ownRating == false) {
      dislikes--;
    }
    ownRating = true;
    currentlyUpdatingVotes = true;
    if (mounted) setState(() {});

    http.Response res = await http.post(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments/rating?uuid=${userData['uuid']}&commentId=${widget.commentData['comment']['_id']}&isPositive=true',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      likes = oldLikes;
      dislikes = oldDislikes;
      ownRating = oldOwnRating;
      currentlyUpdatingVotes = false;
      if (mounted) setState(() {});

      if (res.statusCode == 401) {
        if (mounted) Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }

    widget.commentUpdateStream.sink.add(widget.commentData['comment']['_id']);
    currentlyUpdatingVotes = false;
    if (mounted) setState(() {});
  }

  Future<void> downvote() async {
    if (currentlyUpdatingVotes) return;
    int oldLikes = likes;
    int oldDislikes = dislikes;
    bool? oldOwnRating = ownRating;

    dislikes++;
    if (ownRating == true) {
      likes--;
    }
    ownRating = false;
    currentlyUpdatingVotes = true;
    if (mounted) setState(() {});

    http.Response res = await http.post(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments/rating?uuid=${userData['uuid']}&commentId=${widget.commentData['comment']['_id']}&isPositive=false',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      likes = oldLikes;
      dislikes = oldDislikes;
      ownRating = oldOwnRating;
      currentlyUpdatingVotes = false;
      if (mounted) setState(() {});

      if (res.statusCode == 401) {
        if (mounted) Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    widget.commentUpdateStream.sink.add(widget.commentData['comment']['_id']);
    currentlyUpdatingVotes = false;
    if (mounted) setState(() {});
  }

  Future<void> deleteRating() async {
    if (currentlyUpdatingVotes) return;
    int oldLikes = likes;
    int oldDislikes = dislikes;
    bool? oldOwnRating = ownRating;

    if (ownRating == true) {
      likes--;
    } else {
      dislikes--;
    }
    ownRating = null;
    currentlyUpdatingVotes = true;
    if (mounted) setState(() {});

    http.Response res = await http.delete(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments/rating?uuid=${userData['uuid']}&commentId=${widget.commentData['comment']['_id']}',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      likes = oldLikes;
      dislikes = oldDislikes;
      ownRating = oldOwnRating;
      currentlyUpdatingVotes = false;
      if (mounted) setState(() {});

      if (res.statusCode == 401) {
        if (mounted) Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }

    widget.commentUpdateStream.sink.add(widget.commentData['comment']['_id']);
    currentlyUpdatingVotes = false;
    if (mounted) setState(() {});
  }

  Future<void> report() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ReportMcReal(
          type: ReportType.comment,
          contentId: widget.commentData['comment']['_id'],
        ),
      ),
    );
  }

  Future<void> delete() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isAndroid
            ? AlertDialog(
                title: Text(
                  AppLocalizations.of(context).mcRealDeleteCommentTitle,
                ),
                content: Text(
                  AppLocalizations.of(context).mcRealDeleteCommentContent,
                ),
                backgroundColor: NoRiskClientColors.darkerBackground,
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context).mcRealPopupCancel,
                      style: const TextStyle(color: NoRiskClientColors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      http.Response res = await http.delete(
                        Uri.parse(
                          '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments?uuid=${userData['uuid']}&commentId=${widget.commentData['comment']['_id']}',
                        ),
                        headers: {
                          'Authorization': 'Bearer ${userData['token']}',
                        },
                      );
                      if (res.statusCode != 200) {
                        if (res.statusCode == 401) {
                          if (context.mounted) Navigator.of(context).pop();
                          getUpdateStream.sink.add(['signOut']);
                        }
                        return;
                      }
                      deleted = true;
                      if (mounted) setState(() {});

                      widget.commentUpdateStream.sink.add("*");
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context).mcRealPopupDelete,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: Text(
                  AppLocalizations.of(context).mcRealDeleteCommentTitle,
                ),
                content: Text(
                  AppLocalizations.of(context).mcRealDeleteCommentContent,
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context).mcRealPopupCancel,
                      style: const TextStyle(color: CupertinoColors.activeBlue),
                    ),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () async {
                      http.Response res = await http.delete(
                        Uri.parse(
                          '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments?uuid=${userData['uuid']}&commentId=${widget.commentData['comment']['_id']}',
                        ),
                        headers: {
                          'Authorization': 'Bearer ${userData['token']}',
                        },
                      );
                      if (res.statusCode != 200) {
                        if (res.statusCode == 401) {
                          if (context.mounted) Navigator.of(context).pop();
                          getUpdateStream.sink.add(['signOut']);
                        }
                        return;
                      }
                      deleted = true;
                      if (mounted) setState(() {});
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context).mcRealPopupDelete),
                  ),
                ],
              );
      },
    );
  }
}
