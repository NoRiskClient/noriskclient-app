import 'package:flutter/material.dart';
import 'package:noriskclient/config/Colors.dart';
import 'package:noriskclient/config/ThemeProvider.dart';
import 'package:noriskclient/l10n/app_localizations.dart';
import 'package:noriskclient/widgets/NoRiskContainer.dart';
import 'package:noriskclient/widgets/NoRiskText.dart';
import 'package:noriskclient/widgets/NoRiskBackButton.dart';
import 'package:noriskclient/widgets/NoRiskButton.dart';
import 'package:noriskclient/widgets/SettingsColorInfo.dart';
import 'package:noriskclient/widgets/SettingsHueSlider.dart';
import 'package:noriskclient/widgets/SettingsSaturationValuePicker.dart';
import 'package:provider/provider.dart';

class SettingsColorSelector extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const SettingsColorSelector({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<SettingsColorSelector> createState() => _SettingsColorSelectorState();
}

class _SettingsColorSelectorState extends State<SettingsColorSelector> {
  double hue = 0;
  double saturation = 1;
  double value = 1;

  @override
  void initState() {
    super.initState();
    final hsv = HSVColor.fromColor(widget.initialColor);
    hue = hsv.hue;
    saturation = hsv.saturation;
    value = hsv.value;
  }

  Color get currentColor =>
      HSVColor.fromAHSV(1, hue, saturation, value).toColor();

  void _updateSaturationValue(double newSaturation, double newValue) {
    setState(() {
      saturation = newSaturation;
      value = newValue;
    });
  }

  void _updateHue(double newHue) {
    setState(() {
      hue = newHue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = currentColor;
    final theme = Provider.of<ThemeProvider>(context);

    return Center(
      child: NoRiskContainer(
        width: 400,
        height: 505,
        backgroundOpacity: 255,
        borderOpacity: 140,
        color: theme.darkerBackground,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7.5),
                        child: NoRiskBackButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: NoRiskText(
                        AppLocalizations.of(context)!
                            .theme_color_picker_title
                            .toLowerCase(),
                        spaceTop: false,
                        spaceBottom: false,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SettingsSaturationValuePicker(
                  hue: hue,
                  saturation: saturation,
                  value: value,
                  onChanged: _updateSaturationValue,
                ),
                const SizedBox(height: 16),
                SettingsHueSlider(
                  hue: hue,
                  onChanged: _updateHue,
                ),
                const SizedBox(height: 16),
                SettingsColorInfo(color: selectedColor),
                const SizedBox(height: 30),
                Row(
                  children: [
                    NoRiskContainer(
                      width: 50,
                      height: 50,
                      color: selectedColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NoRiskButton(
                        onTap: () {
                          widget.onColorSelected(selectedColor);
                        },
                        height: 50,
                        child: NoRiskText(
                          AppLocalizations.of(context)!
                              .theme_apply
                              .toLowerCase(),
                          spaceTop: false,
                          spaceBottom: false,
                          style: const TextStyle(
                            color: NoRiskClientColors.text,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
