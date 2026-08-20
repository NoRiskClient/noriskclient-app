import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/screens/profile/profile.dart';
import 'package:noriskclient/screens/mcreal/report_mc_real.dart';
import 'package:noriskclient/services/api_client.dart';
import 'package:noriskclient/utils/nr_icons.dart';
import 'package:noriskclient/models/report_types.dart';
import 'package:noriskclient/widgets/common/loading_indicator.dart';
import 'package:noriskclient/widgets/feed/mcreal_comment_input.dart';
import 'package:noriskclient/widgets/common/nr_button.dart';
import 'package:noriskclient/widgets/common/nr_container.dart';
import 'package:noriskclient/widgets/common/nr_icon_button.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

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
  State<McRealComment> createState() => McRealCommentState();
}

class McRealCommentState extends State<McRealComment> {
  int page = 0;
  bool ownComment = false;
  int likes = 0;
  int dislikes = 0;
  bool? ownRating;
  List<McRealComment> replys = [];
  bool showReplys = false;
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
      () => setState(() {
            cache = getCache;
          }),
    ]);
    ownComment = userData['uuid'] == widget.commentData['comment']['author'];
    if (!ownComment) {
      getUpdateStream.sink.add([
        'loadUsername',
        widget.commentData['comment']['author'],
        () => setState(() {
              cache = getCache;
            }),
      ]);
    }
    likes = widget.commentData['likes'];
    dislikes = widget.commentData['dislikes'];
    if (widget.commentData['userRating'] != null) {
      ownRating = widget.commentData['userRating']?['isPositive'];
    }
    loadReplys();
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
                          child: cache['skins']
                                  ?[widget.commentData['comment']['author']] ??
                              const SizedBox(
                                height: 32,
                                width: 32,
                                child: LoadingIndicator(),
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
                                        )!
                                          .mcRealComment_you
                                      : cache['usernames']?[
                                                  widget.commentData['comment']
                                                      ['author']]
                                              .toString() ??
                                          '',
                                  spaceTop: false,
                                  spaceBottom: false,
                                  style: TextStyle(
                                    fontSize: 13.75,
                                    fontWeight: FontWeight.bold,
                                    color: ownComment
                                        ? NoRiskClientColors.blue
                                        : NoRiskClientColors.text,
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
                                      .split('.')[0],
                                  spaceTop: false,
                                  spaceBottom: false,
                                  style: TextStyle(
                                    fontSize: 13.75,
                                    fontWeight: FontWeight.w500,
                                    color: NoRiskClientColors.textLight,
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
                    widget.commentData['comment']['text'].toString(),
                    spaceTop: false,
                    spaceBottom: false,
                    style: TextStyle(
                      fontSize: 13.75,
                      fontWeight: FontWeight.w500,
                      color: NoRiskClientColors.text,
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
                              fontSize: 17.5,
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
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: NRIcons.svgAsset(
                            'lib/assets/icons/like.svg',
                            color: ownRating == true
                                ? Colors.green
                                : NoRiskClientColors.text,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      NoRiskButton(
                        onTap: ownRating == false ? deleteRating : downvote,
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: NRIcons.svgAsset(
                            'lib/assets/icons/dislike.svg',
                            color: ownRating == false
                                ? Colors.red
                                : NoRiskClientColors.text,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      NoRiskIconButton(
                        onTap: reply,
                        icon: NRIcons.svg(
                          'comment',
                          color: NoRiskClientColors.textLight,
                          size: 20,
                        ),
                      ),
                      if (!ownComment) const SizedBox(width: 10),
                      if (!ownComment)
                        NoRiskIconButton(
                          onTap: report,
                          icon: NRIcons.svg(
                            'flag',
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      const SizedBox(width: 7.5),
                      if (ownComment)
                        NoRiskIconButton(
                          onTap: delete,
                          icon: NRIcons.svg(
                            'trashcan',
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height:
                        replys.isNotEmpty && commentInput is Container ? 5 : 0,
                  ),
                  commentInput,
                  if (replys.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showReplys = !showReplys;
                        });
                      },
                      child: SizedBox(
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.5),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: KeyedSubtree(
                                  key: ValueKey(showReplys),
                                  child: NRIcons.svg(
                                    showReplys ? 'angel_up' : 'angel_down',
                                    color: NoRiskClientColors.textLight,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 7.5),
                            NoRiskText(
                              '${replys.length} ${replys.length > 1 ? AppLocalizations.of(context)!.mcRealComment_replys : AppLocalizations.of(context)!.mcRealComment_reply}',
                              spaceTop: false,
                              spaceBottom: true,
                              style: TextStyle(
                                fontSize: 15,
                                color: NoRiskClientColors.text,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (showReplys)
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
                            child: Column(children: replys),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
  }

  Future<void> loadReplys() async {
    http.Response res = await http.get(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments?uuid=${userData['uuid']}&page=$page&postId=${widget.commentData['comment']['postId']}&parentCommentId=${widget.commentData['comment']['_id']}',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      if (res.statusCode == 401) {
        Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    Map<String, dynamic> commentsData = jsonDecode(utf8.decode(res.bodyBytes));

    List<McRealComment> newReplys = [];
    for (var commentData in commentsData['comments']) {
      newReplys.add(
        McRealComment(
          commentData: commentData,
          commentUpdateStream: widget.commentUpdateStream,
          parentId: widget.commentData['comment']['_id'],
          postUpdateStream: widget.postUpdateStream,
        ),
      );
    }

    setState(() {
      replys = newReplys;
    });
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
    setState(() {
      commentInput = commentInput is McRealCommentInput
          ? Container()
          : McRealCommentInput(
              userData: userData,
              postId: widget.commentData['comment']['postId'],
              parentCommentId: widget.commentData['comment']['_id'],
              refresh: () => widget.commentUpdateStream.sink.add("*"),
            );
    });
  }

  Future<void> upvote() async {
    if (currentlyUpdatingVotes) return;
    int oldLikes = likes;
    int oldDislikes = dislikes;
    bool? oldOwnRating = ownRating;
    setState(() {
      likes++;
      if (ownRating == false) {
        dislikes--;
      }
      ownRating = true;
      currentlyUpdatingVotes = true;
    });
    http.Response res = await http.post(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments/rating?uuid=${userData['uuid']}&commentId=${widget.commentData['comment']['_id']}&isPositive=true',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      setState(() {
        likes = oldLikes;
        dislikes = oldDislikes;
        ownRating = oldOwnRating;
        currentlyUpdatingVotes = false;
      });
      if (res.statusCode == 401) {
        Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    widget.commentUpdateStream.sink.add(widget.commentData['comment']['_id']);
    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() {
        currentlyUpdatingVotes = false;
      }),
    );
  }

  Future<void> downvote() async {
    if (currentlyUpdatingVotes) return;
    int oldLikes = likes;
    int oldDislikes = dislikes;
    bool? oldOwnRating = ownRating;
    setState(() {
      dislikes++;
      if (ownRating == true) {
        likes--;
      }
      ownRating = false;
      currentlyUpdatingVotes = true;
    });
    http.Response res = await http.post(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments/rating?uuid=${userData['uuid']}&commentId=${widget.commentData['comment']['_id']}&isPositive=false',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      setState(() {
        likes = oldLikes;
        dislikes = oldDislikes;
        ownRating = oldOwnRating;
        currentlyUpdatingVotes = false;
      });
      if (res.statusCode == 401) {
        Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    widget.commentUpdateStream.sink.add(widget.commentData['comment']['_id']);
    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() {
        currentlyUpdatingVotes = false;
      }),
    );
  }

  Future<void> deleteRating() async {
    if (currentlyUpdatingVotes) return;
    int oldLikes = likes;
    int oldDislikes = dislikes;
    bool? oldOwnRating = ownRating;
    setState(() {
      if (ownRating == true) {
        likes--;
      } else {
        dislikes--;
      }
      ownRating = null;
      currentlyUpdatingVotes = true;
    });
    http.Response res = await http.delete(
      Uri.parse(
        '${NoRiskApi().getBaseUrl(userData['experimental'], 'mcreal')}/comments/rating?uuid=${userData['uuid']}&commentId=${widget.commentData['comment']['_id']}',
      ),
      headers: {'Authorization': 'Bearer ${userData['token']}'},
    );
    if (res.statusCode != 200) {
      setState(() {
        likes = oldLikes;
        dislikes = oldDislikes;
        ownRating = oldOwnRating;
        currentlyUpdatingVotes = false;
      });
      if (res.statusCode == 401) {
        Navigator.of(context).pop();
        getUpdateStream.sink.add(['signOut']);
      }
      return;
    }
    widget.commentUpdateStream.sink.add(widget.commentData['comment']['_id']);
    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() {
        currentlyUpdatingVotes = false;
      }),
    );
  }

  Future<void> report() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ReportMcReal(
          type: ReportType.COMMENT,
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
                  AppLocalizations.of(context)!.mcReal_deleteCommentPopupTitle,
                ),
                content: Text(
                  AppLocalizations.of(
                    context,
                  )!
                      .mcReal_deleteCommentPopupContent,
                ),
                backgroundColor: NoRiskClientColors.surface,
                titleTextStyle: TextStyle(
                  fontFamily: 'SmallCapsMC',
                  color: NoRiskClientColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                contentTextStyle: TextStyle(
                  fontFamily: 'SmallCapsMC',
                  color: NoRiskClientColors.text,
                  fontSize: 11,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.mcReal_popup_cancel,
                      style: TextStyle(color: NoRiskClientColors.blue),
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
                          Navigator.of(context).pop();
                          getUpdateStream.sink.add(['signOut']);
                        }
                        return;
                      }
                      setState(() {
                        deleted = true;
                      });
                      widget.commentUpdateStream.sink.add("*");
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.mcReal_popup_delete,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.mcReal_deleteCommentPopupTitle,
                ),
                content: Text(
                  AppLocalizations.of(
                    context,
                  )!
                      .mcReal_deleteCommentPopupContent,
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.mcReal_popup_cancel,
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
                          Navigator.of(context).pop();
                          getUpdateStream.sink.add(['signOut']);
                        }
                        return;
                      }
                      setState(() {
                        deleted = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.mcReal_popup_delete,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
