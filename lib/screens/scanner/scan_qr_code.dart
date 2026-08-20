import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:noriskclient/screens/events/giveaway_admin_info.dart';
import 'package:noriskclient/screens/events/giveaway_result.dart';
import 'package:noriskclient/services/api_client.dart';
import 'package:noriskclient/widgets/scanner/qr_scanner_page.dart';

class ScanQRCode extends StatefulWidget {
  final bool isAdminScan;

  const ScanQRCode({super.key, this.isAdminScan = false});

  @override
  _ScanQRCodeState createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  int? lastRedeem;

  @override
  void initState() {
    super.initState();
    lastRedeem = 0;
  }

  @override
  Widget build(BuildContext context) {
    return QrScannerPage(
      onCodeDetected: handleQrCodeResult,
    );
  }

  Future<void> handleQrCodeResult(String code) async {
    if (code.contains("/giveaways/")) {
      String giveawayId = code.split("/")[code.split("/").length - 2];

      if (widget.isAdminScan) {
        Map<String, dynamic> giveawayData =
            await NoRiskApi().getGiveawayAdminInfo(giveawayId);

        if (giveawayData['itemId'] == null) {
          Fluttertoast.showToast(msg: 'Invalid voucher QR code');
          return;
        }
        if (!mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GiveawayAdminInfo(
                  giveawayId: giveawayId,
                  itemId: giveawayData['itemId'],
                  additionalInfo:
                      giveawayData['additionalInformation'] ?? 'null'),
            ));
      } else {
        if (lastRedeem! + 1000 >= DateTime.now().millisecondsSinceEpoch) {
          return;
        }

        Map<String, dynamic>? resultData =
            await NoRiskApi().redeemGiveaway(giveawayId);

        if (resultData == null) {
          Fluttertoast.showToast(msg: 'Invalid voucher QR code');
          return;
        }

        lastRedeem = DateTime.now().millisecondsSinceEpoch;

        if (!mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GiveawayResult(
                itemId: resultData['id'] ?? '',
                itemName: resultData['name'] ?? '',
                itemRarity: resultData['rarity'] ?? '',
                errorMessage: resultData['error'] ?? '',
              ),
            ));
      }
    }
  }
}
