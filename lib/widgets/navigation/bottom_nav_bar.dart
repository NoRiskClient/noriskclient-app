import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/screens/auth/sign_in.dart';
import 'package:noriskclient/utils/nr_icons.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

class NoRiskBottomNavigationBar extends StatefulWidget {
  NoRiskBottomNavigationBar({
    super.key,
    required this.currentIndexController,
    this.currentIndex = 2,
    this.isGuest = false,
    this.pageController,
  });

  final StreamController<int> currentIndexController;
  final int currentIndex;
  final PageController? pageController;
  final bool isGuest;

  @override
  State<NoRiskBottomNavigationBar> createState() =>
      NoRiskBottomNavigationBarState();
}

class NoRiskBottomNavigationBarState extends State<NoRiskBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final double bottomPad =
        isAndroid ? MediaQuery.of(context).viewPadding.bottom : 0;
    final double barHeight = isAndroid ? 54 + bottomPad : 60;

    return Container(
      height: barHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: NoRiskClientColors.surface,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPad),
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth;
          final itemCount = widget.isGuest ? 2 : 4;
          final itemWidth = width / itemCount;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.isGuest
                ? [
                    Expanded(
                      child: _NavButton(
                        index: 0,
                        currentIndex: widget.currentIndex,
                        iconBuilder: (active) => NRIcons.svg(
                          'news',
                          dir: 'widgets',
                          color: active ? NoRiskClientColors.blue : null,
                          size: 22,
                        ),
                        label: 'news',
                        onTap: () {
                          widget.pageController?.jumpToPage(0);
                          widget.currentIndexController.sink.add(0);
                        },
                        maxLabelWidth: itemWidth * 0.9,
                      ),
                    ),
                    Expanded(
                      child: _NavButton(
                        index: 1,
                        currentIndex: widget.currentIndex,
                        iconBuilder: (active) => NRIcons.svg(
                          'user',
                          dir: 'widgets',
                          color: active ? NoRiskClientColors.blue : null,
                          size: 22,
                        ),
                        label: AppLocalizations.of(context)!.navbar_login,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignIn()),
                        ),
                        maxLabelWidth: itemWidth * 0.9,
                      ),
                    ),
                  ]
                : [
                    Expanded(
                      child: _NavButton(
                        index: 0,
                        currentIndex: widget.currentIndex,
                        iconBuilder: (active) => NRIcons.svg(
                          'news',
                          dir: 'widgets',
                          color: active ? NoRiskClientColors.blue : null,
                          size: 22,
                        ),
                        label: 'news',
                        onTap: () => widget.currentIndexController.sink.add(0),
                        maxLabelWidth: itemWidth * 0.9,
                      ),
                    ),
                    Expanded(
                      child: _NavButton(
                        index: 1,
                        currentIndex: widget.currentIndex,
                        iconBuilder: (active) => NRIcons.svg(
                          'chat',
                          dir: 'widgets',
                          color: active ? NoRiskClientColors.blue : null,
                          size: 22,
                        ),
                        label: 'chats',
                        onTap: () {
                          widget.pageController?.jumpToPage(1);
                          widget.currentIndexController.sink.add(1);
                        },
                        maxLabelWidth: itemWidth * 0.9,
                      ),
                    ),
                    Expanded(
                      child: _NavButton(
                        index: 2,
                        currentIndex: widget.currentIndex,
                        iconBuilder: (active) => NRIcons.svg(
                          'camera',
                          dir: 'widgets',
                          color: active ? NoRiskClientColors.blue : null,
                          size: 22,
                        ),
                        label: 'mcreal',
                        onTap: () {
                          widget.pageController?.jumpToPage(2);
                          widget.currentIndexController.sink.add(2);
                        },
                        maxLabelWidth: itemWidth * 0.9,
                      ),
                    ),
                    Expanded(
                      child: _NavButton(
                        index: 3,
                        currentIndex: widget.currentIndex,
                        iconBuilder: (active) => NRIcons.svg(
                          'user',
                          dir: 'widgets',
                          color: active ? NoRiskClientColors.blue : null,
                          size: 22,
                        ),
                        label: AppLocalizations.of(context)!.navbar_you,
                        onTap: () {
                          widget.pageController?.jumpToPage(3);
                          widget.currentIndexController.sink.add(3);
                        },
                        maxLabelWidth: itemWidth * 0.9,
                      ),
                    ),
                  ],
          );
        }),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.onTap,
    required this.currentIndex,
    required this.label,
    required this.iconBuilder,
    required this.index,
    this.maxLabelWidth,
  });

  final void Function() onTap;
  final int currentIndex;
  final String label;
  final Widget Function(bool active) iconBuilder;
  final int index;
  final double? maxLabelWidth;

  @override
  Widget build(BuildContext context) {
    final bool active = currentIndex == index;

    void handleTap() {
      HapticFeedback.selectionClick();
      onTap();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: handleTap,
      child: Semantics(
        button: true,
        selected: active,
        label: label,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Opacity(
                opacity: active ? 1 : 0.55,
                child: iconBuilder(active),
              ),
              const SizedBox(height: 3),
              SizedBox(
                width: maxLabelWidth ?? 70,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: NoRiskText(
                    label,
                    spaceTop: false,
                    spaceBottom: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: active
                          ? NoRiskClientColors.blue
                          : NoRiskClientColors.text.withAlpha(160),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
