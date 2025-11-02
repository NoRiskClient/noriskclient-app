import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../config/colors.dart';
import '../utils/no_risk_api.dart';
import '../widgets/qr_scanner_overlay.dart';
import 'giveaway_admin.dart';
import 'giveaway_result.dart';

class ScanQRCode extends StatefulWidget {
  final bool isAdminScan;

  const ScanQRCode({super.key, this.isAdminScan = false});

  @override
  _ScanQRCodeState createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  MobileScannerController controller = MobileScannerController();
  int? lastRedeem;

  @override
  void initState() {
    super.initState();
    controller.start();
    lastRedeem = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: NoRiskClientColors.background,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: MobileScanner(
              fit: BoxFit.fitHeight,
              controller: controller,
              onDetect: (BarcodeCapture result) {
                handleQrCodeResult(
                  controller,
                  result.barcodes[0].rawValue ?? '',
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: ShapeDecoration(
                shape: QrScannerOverlayShape(
                  borderColor: NoRiskClientColors.light,
                  borderRadius: 10,
                  borderLength: 15,
                  borderWidth: 7.5,
                  cutOutSize: MediaQuery.of(context).size.width / 1.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 40),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  controller.stop();
                  controller.dispose();
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: () async {
                  await controller.toggleTorch();
                },
                icon: const Icon(
                  Icons.flash_on_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleQrCodeResult(
    MobileScannerController controller,
    String code,
  ) async {
    print('QR Code Detected: $code');

    if (code.contains("/giveaways/")) {
      String giveawayId = code.split("/")[code.split("/").length - 2];

      controller.stop();
      controller.dispose();
      if (widget.isAdminScan) {
        Map<String, dynamic> giveawayData = await NoRiskApi()
            .getGiveawayAdminInfo(giveawayId);

        if (giveawayData['itemId'] == null) {
          Fluttertoast.showToast(msg: 'Invalid voucher QR code');
          return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GiveawayAdminInfo(
              giveawayId: giveawayId,
              itemId: giveawayData['itemId'],
              additionalInfo: giveawayData['additionalInformation'] ?? 'null',
            ),
          ),
        );
      } else {
        if (lastRedeem! + 1000 >= DateTime.now().millisecondsSinceEpoch) {
          return;
        }

        Map<String, dynamic>? resultData = await NoRiskApi().redeemGiveaway(
          giveawayId,
        );

        if (resultData == null) {
          Fluttertoast.showToast(msg: 'Invalid voucher QR code');
          return;
        }

        lastRedeem = DateTime.now().millisecondsSinceEpoch;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GiveawayResult(
              itemId: resultData['id'] ?? '',
              itemName: resultData['name'] ?? '',
              itemRarity: resultData['rarity'] ?? '',
              errorMessage: resultData['error'] ?? '',
            ),
          ),
        );
      }
    }
  }
}
