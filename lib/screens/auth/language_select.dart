import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/config/config.dart';
import 'package:noriskclient/providers/locale_provider.dart';
import 'package:noriskclient/widgets/common/nr_button.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelect extends StatelessWidget {
  const LanguageSelect({super.key, required this.onLanguageChosen});

  final void Function() onLanguageChosen;

  Future<void> _chooseLanguage(BuildContext context, String code) async {
    Provider.of<LocaleProvider>(context, listen: false).setLocale(code);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', code);

    onLanguageChosen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoRiskClientColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('lib/assets/app/norisk_logo.png', height: 110),
              const SizedBox(height: 30),
              NoRiskText(
                'Choose your language',
                spaceTop: false,
                spaceBottom: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: NoRiskClientColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              NoRiskText(
                'Wähle deine Sprache',
                spaceTop: false,
                spaceBottom: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: NoRiskClientColors.textLight,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (final code in Config.availableLanguages)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: NoRiskButton(
                            height: 60,
                            width: double.infinity,
                            color: NoRiskClientColors.blue,
                            onTap: () => _chooseLanguage(context, code),
                            child: NoRiskText(
                              Config.languageNames[code] ?? code,
                              spaceTop: false,
                              spaceBottom: false,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              NoRiskText(
                'You can change this later in settings',
                spaceTop: false,
                spaceBottom: false,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: NoRiskClientColors.textLight,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
