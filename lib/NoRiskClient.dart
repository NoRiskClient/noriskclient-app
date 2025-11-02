import 'dart:async';

import 'package:flutter/material.dart';

import 'main.dart';
import 'screens/Chats.dart';
import 'screens/Gamescom.dart';
import 'screens/McReal.dart';
import 'screens/News.dart';
import 'screens/NoRiskProfile.dart';
import 'widgets/BottomNavigationBar.dart';

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
        return Chats(); // Chat
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
      body: Stack(
        children: [
          getActiveTab(),
          Align(
            alignment: Alignment.bottomCenter,
            child: NoRiskBottomNavigationBar(
              currentIndex: tabIndex,
              currentIndexController: activeTabIndexController,
            ),
          ),
        ],
      ),
    );
  }
}
