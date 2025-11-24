import 'dart:async';
import 'package:flutter/material.dart';
import 'package:noriskclient/config/ThemeProvider.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/config/Colors.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/config/Config.dart';
import 'package:noriskclient/provider/localeProvider.dart';
import 'package:noriskclient/screens/ScanQRCode.dart';
import 'package:noriskclient/screens/settings/Blocked.dart';
import 'package:noriskclient/widgets/NoRiskBackButton.dart';
import 'package:noriskclient/widgets/NoRiskContainer.dart';
import 'package:noriskclient/widgets/NoRiskText.dart';
import 'package:noriskclient/widgets/SettingsColorPicker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    loadAppInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, theme, _) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: theme.background,
          body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
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
                            AppLocalizations.of(context)!
                                .settings_title
                                .toLowerCase(),
                            spaceTop: false,
                            spaceBottom: false,
                            style: const TextStyle(
                                color: NoRiskClientColors.text,
                                fontSize: 45,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 160,
                  child: ListView(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        NoRiskText(
                            AppLocalizations.of(context)!
                                .settings_language
                                .toLowerCase(),
                            spaceTop: false,
                            spaceBottom: false,
                            style: const TextStyle(
                                color: NoRiskClientColors.text,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => setLanguage('de'),
                      child: NoRiskContainer(
                        width: double.infinity,
                        height: 50,
                        color: AppLocalizations.of(context)!.localeName == 'de'
                            ? theme.blue
                            : theme.text,
                        child: Center(
                          child: NoRiskText('Deutsch'.toLowerCase(),
                              style: TextStyle(
                                  color: AppLocalizations.of(context)!
                                              .localeName ==
                                          'de'
                                      ? theme.blue
                                      : theme.text,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => setLanguage('en'),
                      child: NoRiskContainer(
                        width: double.infinity,
                        height: 50,
                        color: AppLocalizations.of(context)!.localeName == 'en'
                            ? theme.blue
                            : theme.text,
                        child: Center(
                          child: NoRiskText('English'.toLowerCase(),
                              spaceTop: false,
                              spaceBottom: false,
                              style: TextStyle(
                                  color: AppLocalizations.of(context)!
                                              .localeName ==
                                          'en'
                                      ? theme.blue
                                      : theme.text,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        NoRiskText(
                            AppLocalizations.of(context)!
                                .settings_blockedPlayers
                                .toLowerCase(),
                            spaceTop: false,
                            spaceBottom: false,
                            style: const TextStyle(
                                color: NoRiskClientColors.text,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Blocked())),
                      child: NoRiskContainer(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: NoRiskText(
                              AppLocalizations.of(context)!
                                  .settings_blockedPlayers
                                  .toLowerCase(),
                              spaceTop: false,
                              spaceBottom: false,
                              style: const TextStyle(
                                  color: NoRiskClientColors.text,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        NoRiskText(
                            AppLocalizations.of(context)!
                                .settings_theme
                                .toLowerCase(),
                            spaceTop: false,
                            spaceBottom: false,
                            style: const TextStyle(
                                color: NoRiskClientColors.text,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    SettingsColorPicker(
                      selectedColor: theme.blue,
                      onColorChange: (color) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .setBlue(color);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        NoRiskText(
                            AppLocalizations.of(context)!
                                .settings_legal
                                .toLowerCase(),
                            spaceTop: false,
                            spaceBottom: false,
                            style: const TextStyle(
                                color: NoRiskClientColors.text,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => launchUrl(
                          mode: LaunchMode.externalApplication,
                          Config.termsUrl),
                      child: NoRiskContainer(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: NoRiskText(
                              AppLocalizations.of(context)!
                                  .settings_tos
                                  .toLowerCase(),
                              spaceTop: false,
                              spaceBottom: false,
                              style: const TextStyle(
                                  color: NoRiskClientColors.text,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => launchUrl(
                          mode: LaunchMode.externalApplication,
                          Config.privacyUrl),
                      child: NoRiskContainer(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: NoRiskText(
                              AppLocalizations.of(context)!
                                  .settings_privacyPolicy
                                  .toLowerCase(),
                              spaceTop: false,
                              spaceBottom: false,
                              style: const TextStyle(
                                  color: NoRiskClientColors.text,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => launchUrl(
                          mode: LaunchMode.externalApplication,
                          Config.imprintUrl),
                      child: NoRiskContainer(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: theme.darkerBackground,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: NoRiskText(
                              AppLocalizations.of(context)!
                                  .settings_imprint
                                  .toLowerCase(),
                              spaceTop: false,
                              spaceBottom: false,
                              style: const TextStyle(
                                  color: NoRiskClientColors.text,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        NoRiskText(
                            AppLocalizations.of(context)!
                                .settings_support
                                .toLowerCase(),
                            spaceTop: false,
                            spaceBottom: false,
                            style: const TextStyle(
                                color: NoRiskClientColors.text,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => launchUrl(Config.supportUrl),
                      child: NoRiskContainer(
                        width: double.infinity,
                        height: 50,
                        color: Colors.green,
                        child: Center(
                          child: NoRiskText(
                              AppLocalizations.of(context)!
                                  .settings_support
                                  .toLowerCase(),
                              spaceTop: false,
                              spaceBottom: false,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    if (['DEVELOPER', 'ADMIN'].contains(cache['profiles']
                                ?[getUserData['uuid']]?['nrcUser']?['rank']
                            ?.toString()
                            .toUpperCase() ??
                        'DEFAULT'))
                      Column(children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 5),
                            NoRiskText('Admin Options'.toLowerCase(),
                                spaceTop: false,
                                spaceBottom: false,
                                style: const TextStyle(
                                    color: NoRiskClientColors.text,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ScanQRCode(isAdminScan: true))),
                          child: NoRiskContainer(
                            width: double.infinity,
                            height: 50,
                            child: Center(
                              child: NoRiskText(
                                  'Get Giveaway Info'.toLowerCase(),
                                  spaceTop: false,
                                  spaceBottom: false,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ]),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 5),
                        NoRiskText('Updates'.toLowerCase(),
                            spaceTop: false,
                            spaceBottom: false,
                            style: const TextStyle(
                                color: NoRiskClientColors.text,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () => launchUrl(
                          isAndroid ? Config.playStoreUrl : Config.appStoreUrl),
                      child: NoRiskContainer(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: NoRiskText(
                              (isAndroid ? 'PlayStore' : 'AppStore')
                                  .toLowerCase(),
                              spaceTop: false,
                              spaceBottom: false,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: NoRiskClientColors.text)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        getUpdateStream.sink.add(['signOut']);
                        Navigator.of(context).pop();
                      },
                      child: NoRiskContainer(
                        width: double.infinity,
                        height: 50,
                        color: Colors.red,
                        child: Center(
                          child: NoRiskText(
                              AppLocalizations.of(context)!
                                  .settings_signOut
                                  .toLowerCase(),
                              spaceTop: false,
                              spaceBottom: false,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (packageInfo != null)
                      Center(
                        child: NoRiskText(
                            "Version ${packageInfo!.version} - ${packageInfo!.buildNumber}"
                                .toLowerCase(),
                            spaceTop: false,
                            spaceBottom: false,
                            style: const TextStyle(
                                color: NoRiskClientColors.textLight,
                                fontSize: 25)),
                      ),
                    const SizedBox(height: 5),
                    Center(
                      child: GestureDetector(
                        onTap: () => launchUrlString('https://timlohrer.dev',
                            mode: LaunchMode.externalApplication),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NoRiskText('Made with'.toLowerCase(),
                                spaceTop: false,
                                style: const TextStyle(
                                    color: NoRiskClientColors.textLight,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.5),
                              child: Text(' 🧡 '.toLowerCase(),
                                  style: const TextStyle(
                                      color: NoRiskClientColors.textLight,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold)),
                            ),
                            NoRiskText('by Tim Lohrer'.toLowerCase(),
                                spaceTop: false,
                                style: const TextStyle(
                                    color: NoRiskClientColors.textLight,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ]),
                )
              ])));
    });
  }

  Future<void> setLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(language);
  }

  void loadAppInfo() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = _packageInfo;
    });
  }
}
