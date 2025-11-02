import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../config/colors.dart';
import '../config/config.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../provider/locale_provider.dart';
import '../widgets/NoRiskBackButton.dart';
import '../widgets/no_risk_container.dart';
import '../widgets/no_risk_text.dart';
import 'qr.dart';
import 'settings/blocked.dart';

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
                      AppLocalizations.of(context).settingsTitle,
                      spaceTop: false,
                      spaceBottom: false,
                      style: const TextStyle(
                        color: NoRiskClientColors.text,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 160,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      NoRiskText(
                        AppLocalizations.of(context).settingsLanguage,
                        spaceTop: false,
                        spaceBottom: false,
                        style: const TextStyle(
                          color: NoRiskClientColors.text,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ...List<List<Widget>>.generate(
                    AppLocalizations.supportedLocales.length,
                    (index) {
                      final locale = AppLocalizations.supportedLocales[index];
                      return [
                        SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => setLanguage(locale),
                          child: NoRiskContainer(
                            width: double.infinity,
                            height: 50,
                            color:
                                AppLocalizations.of(context).localeName ==
                                    locale.toLanguageTag()
                                ? NoRiskClientColors.blue
                                : NoRiskClientColors.text,
                            child: Center(
                              child: NoRiskText(
                                lookupAppLocalizations(locale).localeDisplay,
                                style: TextStyle(
                                  color:
                                      AppLocalizations.of(context).localeName ==
                                          locale.toLanguageTag()
                                      ? NoRiskClientColors.blue
                                      : NoRiskClientColors.text,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                  ).expand((element) => element),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Blocked()),
                    ),
                    child: NoRiskContainer(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: NoRiskText(
                          AppLocalizations.of(context).settingsBlockedPlayers,
                          spaceTop: false,
                          spaceBottom: false,
                          style: const TextStyle(
                            color: NoRiskClientColors.text,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      NoRiskText(
                        AppLocalizations.of(context).settingsLegal,
                        spaceTop: false,
                        spaceBottom: false,
                        style: const TextStyle(
                          color: NoRiskClientColors.text,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => launchUrl(
                      mode: LaunchMode.externalApplication,
                      Config.termsUrl,
                    ),
                    child: NoRiskContainer(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: NoRiskText(
                          AppLocalizations.of(context).settingsTos,
                          spaceTop: false,
                          spaceBottom: false,
                          style: const TextStyle(
                            color: NoRiskClientColors.text,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => launchUrl(
                      mode: LaunchMode.externalApplication,
                      Config.privacyUrl,
                    ),
                    child: NoRiskContainer(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: NoRiskText(
                          AppLocalizations.of(context).settingsPrivacyPolicy,
                          spaceTop: false,
                          spaceBottom: false,
                          style: const TextStyle(
                            color: NoRiskClientColors.text,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => launchUrl(
                      mode: LaunchMode.externalApplication,
                      Config.imprintUrl,
                    ),
                    child: NoRiskContainer(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: NoRiskClientColors.darkerBackground,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: NoRiskText(
                          AppLocalizations.of(context).settingsImprint,
                          spaceTop: false,
                          spaceBottom: false,
                          style: const TextStyle(
                            color: NoRiskClientColors.text,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      NoRiskText(
                        AppLocalizations.of(context).settingsSupport,
                        spaceTop: false,
                        spaceBottom: false,
                        style: const TextStyle(
                          color: NoRiskClientColors.text,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                          AppLocalizations.of(context).settingsSupport,
                          spaceTop: false,
                          spaceBottom: false,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (['DEVELOPER', 'ADMIN'].contains(
                    cache['profiles']?[getUserData['uuid']]?['nrcUser']?['rank']
                            ?.toString()
                            .toUpperCase() ??
                        'DEFAULT',
                  ))
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 5),
                            NoRiskText(
                              'Admin Options'.toLowerCase(),
                              spaceTop: false,
                              spaceBottom: false,
                              style: const TextStyle(
                                color: NoRiskClientColors.text,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ScanQRCode(isAdminScan: true),
                            ),
                          ),
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 5),
                      NoRiskText(
                        'Updates'.toLowerCase(),
                        spaceTop: false,
                        spaceBottom: false,
                        style: const TextStyle(
                          color: NoRiskClientColors.text,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => launchUrl(
                      isAndroid ? Config.playStoreUrl : Config.appStoreUrl,
                    ),
                    child: NoRiskContainer(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: NoRiskText(
                          (isAndroid ? 'PlayStore' : 'AppStore').toLowerCase(),
                          spaceTop: false,
                          spaceBottom: false,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: NoRiskClientColors.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
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
                          AppLocalizations.of(context).settingsSignOut,
                          spaceTop: false,
                          spaceBottom: false,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                          fontSize: 25,
                        ),
                      ),
                    ),
                  const SizedBox(height: 5),
                  Center(
                    child: GestureDetector(
                      onTap: () => launchUrlString(
                        'https://timlohrer.dev',
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NoRiskText(
                            'Made with'.toLowerCase(),
                            spaceTop: false,
                            style: const TextStyle(
                              color: NoRiskClientColors.textLight,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.5),
                            child: Text(
                              ' 🧡 '.toLowerCase(),
                              style: const TextStyle(
                                color: NoRiskClientColors.textLight,
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          NoRiskText(
                            'by Tim Lohrer'.toLowerCase(),
                            spaceTop: false,
                            style: const TextStyle(
                              color: NoRiskClientColors.textLight,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setLanguage(Locale locale) async {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(locale);
  }

  void loadAppInfo() async {
    PackageInfo _packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = _packageInfo;
    });
  }
}
