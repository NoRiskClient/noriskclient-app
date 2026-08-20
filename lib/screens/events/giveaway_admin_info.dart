import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/widgets/common/nr_back_button.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';

class GiveawayAdminInfo extends StatefulWidget {
  final String giveawayId;
  final String itemId;
  final String additionalInfo;

  const GiveawayAdminInfo({
    super.key,
    required this.giveawayId,
    required this.itemId,
    required this.additionalInfo,
  });

  @override
  _GiveawayAdminInfoState createState() => _GiveawayAdminInfoState();
}

class _GiveawayAdminInfoState extends State<GiveawayAdminInfo> {
  Map<String, String> GAMESCOM_ITEMS = {
    'b8800aec-7e13-4de7-b712-9bcd7037846a': 'Gamescom 2025 Cape',
    '3864589b-f44f-4d9b-b4e9-373dafb34bfa': 'Gamescom 2025 Aura',
    '2da59760-7cc7-4713-84dc-c955b7bde399': 'Gamescom 2025 Emote',
    'f7adda55-7815-4f1e-8ff5-899f6e0367e7': 'NRC+ 90 Days',
    '79dd06d9-ca94-48a9-9dc1-f93d6247654b': 'NRC+ 30 Days',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: NoRiskClientColors.background,
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 50),
          child: ListView(children: [
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
                      'Giveaway Info'.toLowerCase(),
                      spaceTop: false,
                      spaceBottom: false,
                      style: TextStyle(
                          color: NoRiskClientColors.text,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
            NoRiskText('Giveaway ID'.toLowerCase(), style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
            NoRiskText(widget.giveawayId, style: TextStyle(
              color: Colors.white,
              fontSize: 12.5,
            )),
            SizedBox(height: 10),
            NoRiskText('Item ID'.toLowerCase(), style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
            NoRiskText(widget.itemId.toLowerCase(), style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            )),
            SizedBox(height: 10),
            NoRiskText('Item Name'.toLowerCase(), style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
            NoRiskText(GAMESCOM_ITEMS[widget.itemId]?.toLowerCase() ?? 'unknown?', style: TextStyle(
              color: Colors.white,
              fontSize: 12.5,
            )),
            SizedBox(height: 10),
            NoRiskText('Additional Info'.toLowerCase(), style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
            NoRiskText(widget.additionalInfo.toLowerCase(), style: TextStyle(
              color: Colors.white,
              fontSize: 12.5,
            )),
          ]),
        ));
  }
}
