import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';
import '../../utils/blocking_manager.dart';
import '../../widgets/NoRiskBackButton.dart';
import '../../widgets/no_risk_container.dart';
import '../../widgets/no_risk_text.dart';
import '../../widgets/no_risk_loading_indicator.dart';

class Blocked extends StatefulWidget {
  const Blocked({super.key});

  @override
  State<Blocked> createState() => BlockedState();
}

class BlockedState extends State<Blocked> {
  Map<String, Map<String, dynamic>> cache = getCache;
  Map<String, dynamic> userData = getUserData;
  List<String>? blockedPlayers;

  @override
  void initState() {
    loadBlockedPlayers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: NoRiskClientColors.background,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7.5),
                      child: NoRiskBackButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NoRiskText(
                      AppLocalizations.of(context).settingsBlockedPlayers,
                      spaceTop: false,
                      spaceBottom: false,
                      style: const TextStyle(
                        color: NoRiskClientColors.text,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 190,
              child: blockedPlayers == null
                  ? const Center(child: NoRiskLoadingIndicator())
                  : blockedPlayers!.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: NoRiskText(
                          AppLocalizations.of(context).mcRealBlockedNone,
                          spaceTop: false,
                          spaceBottom: false,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  : ListView(
                      children: blockedPlayers!
                          .map(
                            (uuid) => Column(
                              children: [
                                GestureDetector(
                                  onTap: () => unblock(uuid),
                                  child: NoRiskContainer(
                                    padding: const EdgeInsets.all(8.5),
                                    decoration: BoxDecoration(
                                      color:
                                          NoRiskClientColors.darkerBackground,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            2.5,
                                          ),
                                          child:
                                              cache['skins']?[uuid] ??
                                              const SizedBox(
                                                height: 32,
                                                width: 32,
                                                child: NoRiskLoadingIndicator(),
                                              ),
                                        ),
                                        const SizedBox(width: 10),
                                        NoRiskText(
                                          cache['usernames']?[uuid]
                                                  .toString() ??
                                              'Unknown'.toString(),
                                          spaceTop: false,
                                          spaceBottom: false,
                                          style: const TextStyle(
                                            color: NoRiskClientColors.text,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.handshake,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12.5),
                              ],
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void loadBlockedPlayers() async {
    List<String> _blockedPlayers = await BlockingManager().getBlocked();
    setState(() {
      blockedPlayers = _blockedPlayers;
    });

    for (String uuid in _blockedPlayers) {
      getUpdateStream.sink.add([
        'loadSkin',
        uuid,
        () => setState(() {
          cache = getCache;
        }),
      ]);
      getUpdateStream.sink.add([
        'loadUsername',
        uuid,
        () => setState(() {
          cache = getCache;
        }),
      ]);
    }
  }

  void unblock(String uuid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isAndroid
            ? AlertDialog(
                title: Text(
                  AppLocalizations.of(context).mcRealUnblockUserTitle,
                ),
                content: Text(
                  AppLocalizations.of(context).mcRealUnblockUserContent,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context).mcRealPopupCancel,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await BlockingManager().unblock(uuid);
                      loadBlockedPlayers();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context).mcRealPopupYes,
                      style: const TextStyle(color: NoRiskClientColors.blue),
                    ),
                  ),
                ],
              )
            : CupertinoAlertDialog(
                title: Text(
                  AppLocalizations.of(context).mcRealUnblockUserTitle,
                ),
                content: Text(
                  AppLocalizations.of(context).mcRealUnblockUserContent,
                ),
                actions: [
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context).mcRealPopupCancel),
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () async {
                      await BlockingManager().unblock(uuid);
                      loadBlockedPlayers();
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context).mcRealPopupYes),
                  ),
                ],
              );
      },
    );
  }
}
