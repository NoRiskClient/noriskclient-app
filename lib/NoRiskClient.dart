import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/provider/localeProvider.dart';
import 'package:noriskclient/screens/Friends.dart';
import 'package:noriskclient/screens/Gamescom.dart';
import 'package:noriskclient/screens/McReal.dart';
import 'package:noriskclient/screens/News.dart';
import 'package:noriskclient/screens/NoRiskProfile.dart';
import 'package:noriskclient/widgets/BottomNavigationBar.dart';
import 'package:provider/provider.dart';

class NoRiskClient extends StatefulWidget {
  const NoRiskClient({super.key});

  @override
  State<NoRiskClient> createState() => NoRiskClientState();
}

class NoRiskClientState extends State<NoRiskClient> {
  StreamController<int> activeTabIndexController = StreamController<int>();
  int tabIndex = activeTabIndex;

  @override
  void dispose() {
    activeTabIndexController.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.loadLocale();

    activeTabIndexController.stream.listen((index) {
      updateStream.add(["tabIndex", index]);
      setState(() {
        tabIndex = index;
      });
    });
  }

  Widget getActiveTab() {
    switch (tabIndex) {
      case 0:
        return News(); // News
      case 1:
        return Friends(); // Friends
      case 2:
        return McReal();
      case 3:
        return Gamescom(); // Placeholder
      case 4:
        return Profile(uuid: userData['uuid'], isSettings: true); // You
      default:
        return McReal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(children: [
          getActiveTab(),
          Align(
              alignment: Alignment.bottomCenter,
              child: NoRiskBottomNavigationBar(
                  currentIndex: tabIndex,
                  currentIndexController: activeTabIndexController)),
        ]));
  }
}
