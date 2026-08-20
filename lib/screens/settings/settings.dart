import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/config/config.dart';
import 'package:noriskclient/providers/locale_provider.dart';
import 'package:noriskclient/providers/theme_provider.dart';
import 'package:noriskclient/screens/scanner/scan_qr_code.dart';
import 'package:noriskclient/screens/settings/blocked.dart';
import 'package:noriskclient/widgets/common/nr_back_button.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';
import 'package:noriskclient/widgets/common/color_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:noriskclient/utils/nr_icons.dart';

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
    final loc = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isAdmin = ['DEVELOPER', 'ADMIN'].contains(
      cache['profiles']?[getUserData['uuid']]?['nrcUser']?['rank']
              ?.toString()
              .toUpperCase() ??
          'DEFAULT',
    );

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: NoRiskClientColors.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.5),
                      child: NoRiskBackButton(
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  NoRiskText(
                    loc.settings_title,
                    spaceTop: false,
                    spaceBottom: false,
                    style: TextStyle(
                      color: NoRiskClientColors.text,
                      fontSize: 22.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 48),
                  children: [
                    _SectionHeader(loc.settings_language),
                    _SettingsCard(
                      children: [
                        _LanguageDropdown(
                          value:
                              LocaleProvider.localeCode(localeProvider.locale),
                          onChanged: (language) {
                            if (language != null) {
                              setLanguage(language);
                            }
                          },
                        ),
                      ],
                    ),
                    _SectionHeader(loc.settings_theme),
                    _SettingsCard(
                      children: [
                        _ChoiceRow(
                          label: loc.settings_theme_dark,
                          leadingWidget: NRIcons.svg(
                            'dark',
                            color: NoRiskClientColors.blue,
                            size: 16,
                          ),
                          selected:
                              !Provider.of<ThemeModeProvider>(context)
                                      .hasCustomBackground &&
                                  NoRiskClientColors.mode ==
                                      NoRiskThemeMode.dark,
                          onTap: () => setThemeMode(NoRiskThemeMode.dark),
                        ),
                        _Divider(),
                        _ChoiceRow(
                          label: loc.settings_theme_light,
                          leadingWidget: NRIcons.svg(
                            'light',
                            color: NoRiskClientColors.blue,
                            size: 16,
                          ),
                          selected:
                              !Provider.of<ThemeModeProvider>(context)
                                      .hasCustomBackground &&
                                  NoRiskClientColors.mode ==
                                      NoRiskThemeMode.light,
                          onTap: () => setThemeMode(NoRiskThemeMode.light),
                        ),
                      ],
                    ),
                    _SectionHeader(loc.settings_backgroundColor),
                    _SettingsCard(
                      children: [
                        _AccentColorPicker(
                          color: Provider.of<ThemeModeProvider>(context)
                              .backgroundColor,
                          savedColors: Provider.of<ThemeModeProvider>(context)
                              .savedBackgroundColors,
                          label: loc.settings_backgroundColor,
                          customLabel: loc.settings_customBackgroundColor,
                          onChanged: (color) =>
                              Provider.of<ThemeModeProvider>(
                                context,
                                listen: false,
                              ).setBackgroundColor(color),
                        ),
                      ],
                    ),
                    _SectionHeader(loc.settings_customization),
                    _SettingsCard(
                      children: [
                        _BorderRadiusSlider(
                          value: Provider.of<ThemeModeProvider>(context)
                              .borderRadius,
                          onChanged: (value) =>
                              Provider.of<ThemeModeProvider>(
                                context,
                                listen: false,
                              ).setBorderRadius(value),
                          label: loc.settings_borderRadius,
                        ),
                        _Divider(),
                        _AccentColorPicker(
                          color: Provider.of<ThemeModeProvider>(context)
                              .accentColor,
                          savedColors: Provider.of<ThemeModeProvider>(context)
                              .savedAccentColors,
                          label: loc.settings_accentColor,
                          customLabel: loc.settings_customColor,
                          onChanged: (color) =>
                              Provider.of<ThemeModeProvider>(
                                context,
                                listen: false,
                              ).setAccentColor(color),
                        ),
                      ],
                    ),
                    _SectionHeader(loc.settings_blockedPlayers),
                    _SettingsCard(
                      children: [
                        _NavRow(
                          label: loc.settings_blockedPlayers,
                          leadingIcon: Icons.block_rounded,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Blocked(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _SectionHeader(loc.settings_legal),
                    _SettingsCard(
                      children: [
                        _NavRow(
                          label: loc.settings_tos,
                          leadingWidget: NRIcons.svg(
                            'terms',
                            color: NoRiskClientColors.blue,
                            size: 16,
                          ),
                          leadingIconColor: NoRiskClientColors.blue,
                          onTap: () => launchUrl(
                            Config.termsUrl,
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                        _Divider(),
                        _NavRow(
                          label: loc.settings_privacyPolicy,
                          leadingWidget: NRIcons.svg(
                            'bookmark',
                            color: NoRiskClientColors.blue,
                            size: 16,
                          ),
                          leadingIconColor: NoRiskClientColors.blue,
                          onTap: () => launchUrl(
                            Config.privacyUrl,
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                        _Divider(),
                        _NavRow(
                          label: loc.settings_imprint,
                          leadingWidget: NRIcons.svg(
                            'info_circle',
                            color: NoRiskClientColors.blue,
                            size: 16,
                          ),
                          leadingIconColor: NoRiskClientColors.blue,
                          onTap: () => launchUrl(
                            Config.imprintUrl,
                            mode: LaunchMode.externalApplication,
                          ),
                        ),
                      ],
                    ),
                    _SectionHeader(loc.settings_support),
                    _SettingsCard(
                      children: [
                        _NavRow(
                          label: loc.settings_support,
                          leadingWidget: NRIcons.svg(
                            'support',
                            color: NoRiskClientColors.success,
                            size: 16,
                          ),
                          leadingIconColor: NoRiskClientColors.success,
                          onTap: () => launchUrl(Config.supportUrl),
                        ),
                      ],
                    ),
                    if (isAdmin) ...[
                      _SectionHeader('Admin Options'),
                      _SettingsCard(
                        children: [
                          _NavRow(
                            label: 'Get Giveaway Info',
                            leadingIcon: Icons.qr_code_scanner_rounded,
                            leadingIconColor: NoRiskClientColors.blue,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScanQRCode(isAdminScan: true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    _SectionHeader('Updates'),
                    _SettingsCard(
                      children: [
                        _NavRow(
                          label: isAndroid ? 'PlayStore' : 'AppStore',
                          leadingIcon: isAndroid
                              ? Icons.shop_rounded
                              : Icons.apple_rounded,
                          onTap: () => launchUrl(
                            isAndroid
                                ? Config.playStoreUrl
                                : Config.appStoreUrl,
                          ),
                        ),
                      ],
                    ),
                    _SectionHeader(loc.settings_contributors),
                    _SettingsCard(
                      children: [
                        _NavRow(
                          label: loc.settings_contributors,
                          leadingIcon: Icons.groups_rounded,
                          onTap: () => _showContributors(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SettingsCard(
                      children: [
                        _NavRow(
                          label: loc.settings_signOut,
                          leadingWidget: NRIcons.svg(
                            'sign_out',
                            color: NoRiskClientColors.danger,
                            size: 16,
                          ),
                          leadingIconColor: NoRiskClientColors.danger,
                          labelColor: NoRiskClientColors.danger,
                          showChevron: false,
                          onTap: () {
                            getUpdateStream.sink.add(['signOut']);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (packageInfo != null)
                      Center(
                        child: NoRiskText(
                          'Version ${packageInfo!.version} (${packageInfo!.buildNumber})',
                          spaceTop: false,
                          spaceBottom: false,
                          style: TextStyle(
                            color: NoRiskClientColors.textLight,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    provider.setLocale(language);
  }

  void setThemeMode(NoRiskThemeMode mode) {
    setState(() {
      Provider.of<ThemeModeProvider>(context, listen: false).setMode(mode);
    });
  }

  void loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      packageInfo = info;
    });
  }

  void _showContributors(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NoRiskClientColors.surface,
        title: Text(
          AppLocalizations.of(context)!.settings_contributors,
          style: TextStyle(
            fontFamily: 'SmallCapsMC',
            color: NoRiskClientColors.text,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContributorRow(
              name: 'Tim Lohrer',
              contribution: 'NoRisk Client',
              githubUrl: 'https://github.com/TimLohrer',
            ),
            const SizedBox(height: 10),
            _ContributorRow(
              name: 'Nevio N.',
              contribution: 'App Redesigner',
              githubUrl: 'https://github.com/DarkPhoenix1512',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.settings_close,
              style: TextStyle(
                fontFamily: 'SmallCapsMC',
                color: NoRiskClientColors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributorRow extends StatelessWidget {
  const _ContributorRow({
    required this.name,
    required this.contribution,
    required this.githubUrl,
  });

  final String name;
  final String contribution;
  final String githubUrl;

  Future<void> _openGithub() async {
    final uri = Uri.parse(githubUrl);
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NoRiskClientColors.background.withAlpha(70),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _openGithub,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: NoRiskClientColors.blue.withAlpha(30),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: NoRiskClientColors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'SmallCapsMC',
                        color: NoRiskClientColors.text,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      contribution,
                      style: TextStyle(
                        fontFamily: 'SmallCapsMC',
                        color: NoRiskClientColors.textLight,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: NoRiskClientColors.blue.withAlpha(25),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: NoRiskClientColors.blue.withAlpha(60),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.code_rounded,
                      color: NoRiskClientColors.blue,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'GitHub',
                      style: TextStyle(
                        fontFamily: 'SmallCapsMC',
                        color: NoRiskClientColors.blue,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.arrow_outward_rounded,
                      color: NoRiskClientColors.blue,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 6),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'SmallCapsMC',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: NoRiskClientColors.textLight,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NoRiskClientColors.surface,
        borderRadius: BorderRadius.circular(
          NoRiskClientColors.borderRadius,
        ),
        border: Border.all(
          color: NoRiskClientColors.light.withAlpha(120),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 0,
      endIndent: 0,
      color: NoRiskClientColors.light.withAlpha(100),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.label,
    required this.onTap,
    this.leadingIcon,
    this.leadingWidget,
    this.leadingIconColor,
    this.labelColor,
    this.showChevron = true,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? leadingIcon;
  final Widget? leadingWidget;
  final Color? leadingIconColor;
  final Color? labelColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final iconColor = leadingIconColor ?? NoRiskClientColors.blue;
    final textColor = labelColor ?? NoRiskClientColors.text;
    final hasLeading = leadingIcon != null || leadingWidget != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            if (hasLeading) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: leadingWidget != null
                      ? leadingWidget!
                      : Icon(
                          leadingIcon,
                          size: 16,
                          color: iconColor,
                        ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'SmallCapsMC',
                  fontSize: 11,
                  color: textColor,
                ),
              ),
            ),
            if (showChevron)
              NRIcons.svg(
                'chevron_right',
                color: NoRiskClientColors.textLight,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.leadingWidget,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            if (leadingWidget != null) ...[
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: NoRiskClientColors.blue.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: leadingWidget!),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'SmallCapsMC',
                  fontSize: 11,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                  color: selected
                      ? NoRiskClientColors.blue
                      : NoRiskClientColors.text,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_rounded,
                size: 22,
                color: NoRiskClientColors.blue,
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: NoRiskClientColors.background.withAlpha(100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: Config.availableLanguages.contains(value)
                    ? value
                    : null,
                isExpanded: true,
                icon: NRIcons.svg(
                  'angel_down',
                  color: NoRiskClientColors.textLight,
                  size: 16,
                ),
                dropdownColor: NoRiskClientColors.darkerBackground,
                borderRadius: BorderRadius.circular(12),
                elevation: 0,
                menuMaxHeight: 280,
                itemHeight: 52,
                style: TextStyle(
                  fontFamily: 'SmallCapsMC',
                  fontSize: 11,
                  color: NoRiskClientColors.text,
                ),
                items: [
                  for (final language in Config.availableLanguages)
                    DropdownMenuItem<String>(
                      value: language,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: language == value
                                  ? NoRiskClientColors.blue
                                  : NoRiskClientColors.textLight
                                      .withAlpha(100),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            Config.languageNames[language] ?? language,
                          ),
                        ],
                      ),
                    ),
                ],
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BorderRadiusSlider extends StatefulWidget {
  const _BorderRadiusSlider({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final String label;

  @override
  State<_BorderRadiusSlider> createState() => _BorderRadiusSliderState();
}

class _BorderRadiusSliderState extends State<_BorderRadiusSlider> {
  late int lastSnappedValue = widget.value.round();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.label, style: _rowStyle()),
              ),
              Text(
                '${widget.value.round()} px',
                style: TextStyle(
                  fontFamily: 'SmallCapsMC',
                  fontSize: 11,
                  color: NoRiskClientColors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: widget.value.clamp(0, 20),
            min: 0,
            max: 20,
            divisions: 20,
            label: '${widget.value.round()} px',
            activeColor: NoRiskClientColors.blue,
            onChanged: (value) {
              final snapped = value.round();
              if (snapped != lastSnappedValue) {
                lastSnappedValue = snapped;
                HapticFeedback.selectionClick();
              }
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

class _AccentColorPicker extends StatelessWidget {
  const _AccentColorPicker({
    required this.color,
    required this.label,
    required this.customLabel,
    required this.onChanged,
    this.savedColors = const [],
  });

  final Color? color;
  final String label;
  final String customLabel;
  final ValueChanged<Color?> onChanged;
  final List<Color> savedColors;

  static const _palette = [
    Color(0xff3493eb),
    Color(0xff8b5cf6),
    Color(0xffec4899),
    Color(0xffef4444),
    Color(0xfff97316),
    Color(0xffeab308),
    Color(0xff22c55e),
    Color(0xff14b8a6),
    Color(0xff06b6d4),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: _rowStyle(),
          ),
          const SizedBox(height: 12),
          if (savedColors.isNotEmpty) ...[
            Text(
              loc.settings_savedColors,
              style: TextStyle(
                fontFamily: 'SmallCapsMC',
                fontSize: 9,
                color: NoRiskClientColors.textLight,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final saved in savedColors)
                  _ColorSwatch(
                    color: saved,
                    selected: color?.value == saved.value,
                    onTap: () => onChanged(saved),
                  ),
              ],
            ),
            const SizedBox(height: 14),

            // Einziger Trenner zwischen gespeicherten Farben
            // und der Standard-Farbpalette. 20 px Abstand links/rechts.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 1,
                thickness: 1,
                color: NoRiskClientColors.light.withAlpha(100),
              ),
            ),

            const SizedBox(height: 14),
          ],
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final swatch in _palette)
                _ColorSwatch(
                  color: swatch,
                  selected: color?.value == swatch.value,
                  onTap: () => onChanged(swatch),
                ),
              _ColorSwatch(
                color: color ?? NoRiskClientColors.blue,
                selected: color == null,
                onTap: () => onChanged(null),
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 16,
                ),
              ),
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () async {
                    final picked = await showDialog<Color>(
                      context: context,
                      builder: (_) => _CustomColorDialog(
                        initialColor:
                            color ?? NoRiskClientColors.blue,
                        title: customLabel,
                      ),
                    );

                    if (picked != null) {
                      onChanged(picked);
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: NoRiskClientColors.textLight,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.colorize_rounded,
                      size: 20,
                      color: NoRiskClientColors.text,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

TextStyle _rowStyle() => TextStyle(
      fontFamily: 'SmallCapsMC',
      fontSize: 11,
      color: NoRiskClientColors.text,
    );

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
    this.child,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? NoRiskClientColors.text
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(100),
              blurRadius: selected ? 8 : 2,
            ),
          ],
        ),
        child: child ??
            (selected
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  )
                : null),
      ),
    );
  }
}

class _CustomColorDialog extends StatefulWidget {
  const _CustomColorDialog({
    required this.initialColor,
    required this.title,
  });

  final Color initialColor;
  final String title;

  @override
  State<_CustomColorDialog> createState() => _CustomColorDialogState();
}

class _CustomColorDialogState extends State<_CustomColorDialog> {
  late int red = widget.initialColor.red;
  late int green = widget.initialColor.green;
  late int blue = widget.initialColor.blue;

  late double hue = HSVColor.fromColor(widget.initialColor).hue;

  late final TextEditingController hexController =
      TextEditingController(
    text: _hex(widget.initialColor).substring(1),
  );

  String _hex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color get currentColor {
    return Color.fromARGB(
      255,
      red,
      green,
      blue,
    );
  }

  void updateColor(Color color) {
    final hsv = HSVColor.fromColor(color);

    setState(() {
      red = color.red;
      green = color.green;
      blue = color.blue;
      hue = hsv.hue;
      hexController.text = _hex(color).substring(1);
    });
  }

  void updateFromHex(String value) {
    final normalized = value.replaceFirst('#', '');

    if (normalized.length != 6) {
      return;
    }

    final parsed = int.tryParse(
      'FF$normalized',
      radix: 16,
    );

    if (parsed == null) {
      return;
    }

    updateColor(Color(parsed));
  }

  void updateRed(double value) {
    updateColor(
      Color.fromARGB(
        255,
        value.round(),
        green,
        blue,
      ),
    );
  }

  void updateGreen(double value) {
    updateColor(
      Color.fromARGB(
        255,
        red,
        value.round(),
        blue,
      ),
    );
  }

  void updateBlue(double value) {
    updateColor(
      Color.fromARGB(
        255,
        red,
        green,
        value.round(),
      ),
    );
  }

  void updateHue(double value) {
    final hsv = HSVColor.fromColor(currentColor);

    updateColor(
      hsv.withHue(value).toColor(),
    );
  }

  @override
  void dispose() {
    hexController.dispose();
    super.dispose();
  }

  Widget channel(
    String name,
    int value,
    ValueChanged<double> onChanged,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 22,
          child: Text(
            name,
            style: _rowStyle(),
          ),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble().clamp(0.0, 255.0),
            min: 0,
            max: 255,
            divisions: 255,
            activeColor: currentColor,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$value',
            style: _rowStyle(),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: NoRiskClientColors.surface,
      surfaceTintColor: Colors.transparent,
      title: Text(
        widget.title,
        style: _rowStyle().copyWith(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 52,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: BorderRadius.circular(
                    NoRiskClientColors.borderRadius,
                  ),
                  border: Border.all(
                    color: NoRiskClientColors.light.withAlpha(100),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              NoRiskColorPicker(
                color: currentColor,
                hue: hue,
                onColorChanged: updateColor,
                onHueChanged: updateHue,
              ),
              const SizedBox(height: 18),
              TextField(
                controller: hexController,
                maxLength: 6,
                style: _rowStyle(),
                decoration: InputDecoration(
                  labelText: 'HEX',
                  counterText: '',
                  prefixText: '#',
                  filled: true,
                  fillColor:
                      NoRiskClientColors.background.withAlpha(100),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: NoRiskClientColors.light.withAlpha(100),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: NoRiskClientColors.light.withAlpha(100),
                    ),
                  ),
                ),
                onChanged: updateFromHex,
              ),
              const SizedBox(height: 8),
              channel('R', red, updateRed),
              channel('G', green, updateGreen),
              channel('B', blue, updateBlue),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'SmallCapsMC',
              color: NoRiskClientColors.textLight,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: NoRiskClientColors.blue,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              currentColor,
            );
          },
          child: Text(
            'OK',
            style: TextStyle(
              fontFamily: 'SmallCapsMC',
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}