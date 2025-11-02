import 'dart:async';

import 'package:flutter/material.dart';
import '../config/Colors.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../utils/NoRiskIcon.dart';
import 'NoRiskContainer.dart';
import 'NoRiskIconButton.dart';
import 'NoRiskText.dart';

class NoRiskBottomNavigationBar extends StatefulWidget {
  NoRiskBottomNavigationBar({
    super.key,
    required this.currentIndexController,
    this.currentIndex = 2,
  });

  final StreamController<int> currentIndexController;
  int currentIndex;

  @override
  State<NoRiskBottomNavigationBar> createState() =>
      NoRiskBottomNavigationBarState();
}

class NoRiskBottomNavigationBarState extends State<NoRiskBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return NoRiskContainer(
      height: isAndroid ? 60 + MediaQuery.of(context).viewPadding.bottom : 70,
      width: MediaQuery.of(context).size.width,
      color: NoRiskClientColors.light,
      backgroundOpacity: 225,
      borderOpacity: 200,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: isAndroid ? MediaQuery.of(context).viewPadding.bottom : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _BottomNavigationBarButton(
              index: 0,
              currentIndex: widget.currentIndex,
              icon: NoRiskIcon.news,
              label: 'news',
              onTap: () => widget.currentIndexController.sink.add(0),
            ),
            _BottomNavigationBarButton(
              index: 1,
              currentIndex: widget.currentIndex,
              icon: NoRiskIcon.chats,
              label: 'chats',
              onTap: () => widget.currentIndexController.sink.add(1),
            ),
            _BottomNavigationBarButton(
              index: 2,
              currentIndex: widget.currentIndex,
              icon: NoRiskIcon.mcreal,
              label: 'mcreal',
              onTap: () => widget.currentIndexController.sink.add(2),
            ),
            // _BottomNavigationBarButton(
            //   index: 3,
            //   currentIndex: widget.currentIndex,
            //   icon: NoRiskIcon.friends,
            //   label: 'friends',
            //   onTap: () => widget.currentIndexController.sink.add(3),
            //   disabled: true,
            // ),
            _BottomNavigationBarButton(
              index: 3,
              currentIndex: widget.currentIndex,
              icon: NoRiskIcon.gamescom,
              label: 'gamescom',
              onTap: () => widget.currentIndexController.sink.add(3),
              fontSize: 21,
              disabled: true, // DateTime.now().isBefore(DateTime(2025, 8, 20))
            ),
            _BottomNavigationBarButton(
              index: 4,
              currentIndex: widget.currentIndex,
              icon: NoRiskIcon.profile,
              label: AppLocalizations.of(context).navbarYou,
              onTap: () => widget.currentIndexController.sink.add(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigationBarButton extends StatelessWidget {
  const _BottomNavigationBarButton({
    super.key,
    required this.onTap,
    required this.currentIndex,
    required this.label,
    required this.icon,
    required this.index,
    this.disabled = false,
    this.fontSize = 23.5,
  });

  final void Function() onTap;
  final int currentIndex;
  final String label;
  final Widget icon;
  final int index;
  final bool disabled;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? () {} : onTap,
      child: Stack(
        children: [
          SizedBox(
            width: 65,
            height: 55,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: NoRiskIconButton(
                  onTap: disabled ? () {} : onTap,
                  transparent: true,
                  height: 35,
                  width: 35,
                  icon: Opacity(
                    opacity: disabled
                        ? 0.4
                        : currentIndex == index
                        ? 1
                        : 0.75,
                    child: icon,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 65,
            height: 55,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: NoRiskText(
                  label,
                  spaceTop: false,
                  spaceBottom: false,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: disabled
                        ? Colors.white.withAlpha((100).floor())
                        : currentIndex == index
                        ? Colors.white
                        : Colors.white.withAlpha((200).floor()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
