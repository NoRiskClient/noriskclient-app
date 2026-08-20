import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

class WelcomeSplash extends StatelessWidget {
  const WelcomeSplash({
    super.key,
    this.playerName,
    this.showWelcome = false,
  });

  final String? playerName;
  final bool showWelcome;

  @override
  Widget build(BuildContext context) {
    final language = Localizations.localeOf(context).languageCode;
    final welcome = {
      'de': 'Willkommen',
      'en': 'Welcome',
      'es': 'Bienvenido',
      'fr': 'Bienvenue',
      'it': 'Benvenuto',
      'ja': 'ようこそ',
      'ko': '환영합니다',
      'pl': 'Witamy',
      'pt': 'Bem-vindo',
      'ru': 'Добро пожаловать',
      'tr': 'Hoş geldiniz',
      'zh': '欢迎',
    }[language];
    return Scaffold(
      backgroundColor: NoRiskClientColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('lib/assets/app/flash.png', height: 140),
              if (showWelcome && welcome != null) ...[
                const SizedBox(height: 28),
                NoRiskText(
                  welcome,
                  spaceTop: false,
                  spaceBottom: false,
                  style: TextStyle(
                    color: NoRiskClientColors.text,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              if (playerName != null && playerName!.isNotEmpty) ...[
                NoRiskText(
                  playerName!,
                  spaceTop: false,
                  spaceBottom: false,
                  style: TextStyle(
                    color: NoRiskClientColors.textLight,
                    fontSize: 20,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
