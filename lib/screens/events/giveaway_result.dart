import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/main.dart';
import 'package:noriskclient/widgets/common/nr_back_button.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

class GiveawayResult extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String itemRarity;
  final String errorMessage;

  const GiveawayResult({
    super.key, 
    required this.itemId,
    required this.itemName,
    required this.itemRarity,
    this.errorMessage = '',
  });

  @override
  _GiveawayResultState createState() => _GiveawayResultState();
}

class _GiveawayResultState extends State<GiveawayResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NoRiskClientColors.background,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
        child: Column(
          children: [
            SizedBox(height: isAndroid ? 40 : 60),
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
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.errorMessage.isNotEmpty ? [
                  SizedBox(height: MediaQuery.of(context).size.height / 4),
                  NoRiskText(
                    'Error!'.toLowerCase(),
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 27.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  NoRiskText(
                    widget.errorMessage.toLowerCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: NoRiskClientColors.text,
                      fontSize: 12.5,
                    ),
                  ),
                ] : [
                  SizedBox(height: MediaQuery.of(context).size.height / 4),
                  NoRiskText(
                    'Congratulations!'.toLowerCase(),
                    style: TextStyle(
                      color: NoRiskClientColors.text,
                      fontSize: 27.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  NoRiskText(
                    'You have won a giveaway item!'.toLowerCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: NoRiskClientColors.text,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  NoRiskText(
                    widget.itemName.toLowerCase(),
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 22.5,
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
}
