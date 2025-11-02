import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'client.dart';
import 'config/colors.dart';
import 'l10n/app_localizations.dart';
import 'provider/locale_provider.dart';
import 'screens/sign_in.dart';
import 'utils/no_risk_icon.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      builder: (_, _) => const App(),
    ),
  );
}

late bool isIOS;
late bool isAndroid;
Map<String, dynamic> userData = {
  'uuid': '',
  'experimental': false,
  'token': '',
};
Map<String, Map<String, dynamic>> cache = {
  'skins': {},
  'armorSkins': {},
  'usernames': {},
  'posts': {},
  'profiles': {},
};
int activeTabIndex = 2;
final StreamController<List> updateStream = StreamController<List>(sync: true);

Map<String, Map<String, dynamic>> get getCache => cache;
Map<String, dynamic> get getUserData => userData;
StreamController<List> get getUpdateStream => updateStream;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  Widget app = Container();
  StreamController<int> activeTabIndexController = StreamController<int>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => NoRiskIcon.preloadIcons(context),
    );

    isIOS =
        Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;
    isAndroid =
        Theme.of(context).platform == TargetPlatform.android ||
        Theme.of(context).platform == TargetPlatform.fuchsia;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LocaleProvider>(context, listen: false);
      provider.loadLocale().then((_) {
        if (mounted) setState(() {});
      });
    });

    super.initState();

    loadUserData();
    updateStream.stream.listen((List data) async {
      String event = data[0];
      if (event == 'signIn') {
        if (kDebugMode) print('Signing in');
        saveUserData(data[1]);
      } else if (event == 'signOut') {
        if (kDebugMode) print('Signing out');
        if (mounted && Navigator.canPop(context)) Navigator.pop(context);
        activeTabIndex = 2;
        clearUserData();
        clearCache();
      } else if (event == 'tabIndex') {
        activeTabIndex = data[1];
      } else if (event == 'clearCache') {
        clearCache();
      } else if (event == 'loadUserData') {
        await loadUserData();
      } else if (event == 'loadSkin') {
        if (cache['skins']?[data[1]] == null ||
            cache['armorSkins']?[data[1]] == null) {
          loadSkin(data[1]);
        }
        if (data.length > 2) data[2]();
      } else if (event == 'loadUsername') {
        if (cache['usernames']?[data[1]] == null) {
          await loadUsername(data[1]);
        }
        if (data.length > 2) data[2]();
      } else if (event == 'cacheProfile') {
        cache['profiles']?[data[1]] = data[2];
        if (mounted) setState(() {});
      }
    });

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    if (isAndroid) {
      app = MaterialApp(
        title: 'NoRisk Client',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: provider.locale,
        localeListResolutionCallback: (locales, supportedLocales) {
          final provider = Provider.of<LocaleProvider>(context);
          return provider.locale;
        },
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            backgroundColor: NoRiskClientColors.background,
          ),
          textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'SmallCapsMC',
            fontSizeFactor: 1.25,
            displayColor: Colors.white,
            bodyColor: Colors.white,
          ),
        ),
        home: MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: userData['token'] != '' ? NoRiskClient() : const SignIn(),
        ),
      );
    } else if (isIOS) {
      app = CupertinoApp(
        title: 'NoRisk Client',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: provider.locale,
        theme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
              color: Colors.white,
              fontFamily: "SmallCapsMC",
            ),
          ),
        ),
        home: MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: userData['token'] != '' ? NoRiskClient() : const SignIn(),
        ),
      );
    }

    return app;
  }

  bool validUserData() {
    return userData['uuid'] != '' && userData['uuid'] != '';
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userData = {
      'uuid': prefs.getString('uuid') ?? '',
      'experimental': prefs.getBool('experimental') ?? false,
      'token': prefs.getString('token') ?? '',
    };
    if (mounted) setState(() {});
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uuid', userData['uuid'] ?? '');
    await prefs.setBool('experimental', userData['experimental'] ?? false);
    await prefs.setString('token', userData['token'] ?? '');
    loadUserData();
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uuid');
    await prefs.remove('experimental');
    await prefs.remove('token');
    loadUserData();
  }

  void clearCache() {
    cache = {
      'skins': {},
      'armorSkins': {},
      'usernames': {},
      'posts': {},
      'profiles': {},
    };
    if (mounted) setState(() {});
  }

  void loadSkin(String uuid) {
    if (cache['skins']?[uuid] == null) {
      cache['skins']?[uuid] = Image.network(
        'https://mineskin.eu/helm/$uuid/64',
        width: 32,
        height: 32,
      );
    }
    if (cache['armorSkins']?[uuid] == null) {
      cache['armorSkins']?[uuid] = Image.network(
        'https://mineskin.eu/armor/bust/$uuid/128.png',
        height: 175,
        width: 175,
      );
    }
    if (mounted) setState(() {});
  }

  Future<void> loadUsername(String uuid) async {
    if (cache['usernames']?[uuid] == null) {
      http.Response res = await http.get(
        Uri.parse(
          'https://sessionserver.mojang.com/session/minecraft/profile/$uuid',
        ),
      );
      if (res.statusCode != 200) return;

      cache['usernames']?[uuid] = jsonDecode(res.body)['name'];
      if (mounted) setState(() {});
    }
  }
}
