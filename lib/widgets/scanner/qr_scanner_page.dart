import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/widgets/scanner/qr_scanner_overlay.dart';

/// A reusable QR scanner screen with explicit camera lifecycle management.
///
/// The scanner is started after the [MobileScanner] widget is attached. This
/// avoids the start race that can happen when `start()` is called while the
/// widget is still being built.
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({
    required this.onCodeDetected,
    super.key,
  });

  final Future<void> Function(String code) onCodeDetected;

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  late final MobileScannerController _controller;
  bool _isHandlingCode = false;
  bool _isClosing = false;
  Object? _cameraError;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      autoStart: false,
      formats: const [BarcodeFormat.qrCode],
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_startScanner());
    });
  }

  Future<void> _startScanner() async {
    if (!mounted || _isClosing) {
      return;
    }

    try {
      await _controller.start();
      if (mounted) {
        setState(() => _cameraError = null);
      }
    } catch (error, stackTrace) {
      debugPrint('QR scanner could not start: $error\n$stackTrace');
      if (mounted) {
        setState(() => _cameraError = error);
      }
    }
  }

  Future<void> _handleCapture(BarcodeCapture capture) async {
    if (_isHandlingCode || _isClosing) {
      return;
    }

    String? code;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();
      if (value != null && value.isNotEmpty) {
        code = value;
        break;
      }
    }
    if (code == null) {
      return;
    }

    _isHandlingCode = true;
    await _controller.stop();

    try {
      await widget.onCodeDetected(code);
    } finally {
      if (mounted && !_isClosing) {
        _isHandlingCode = false;
        await _startScanner();
      }
    }
  }

  Future<void> _close() async {
    if (_isClosing) {
      return;
    }
    _isClosing = true;
    await _controller.stop();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _isClosing = true;
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraError = _cameraError;

    return Scaffold(
      backgroundColor: NoRiskClientColors.background,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: MobileScanner(
              fit: BoxFit.fitHeight,
              controller: _controller,
              onDetect: (capture) => unawaited(_handleCapture(capture)),
              errorBuilder: (context, error) => _CameraErrorView(
                error: cameraError ?? error,
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
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
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: _close,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: IconButton(
                onPressed: _cameraError == null
                    ? () => unawaited(_controller.toggleTorch())
                    : null,
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
}

class _CameraErrorView extends StatelessWidget {
  const _CameraErrorView({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              color: Colors.white,
              size: 52,
            ),
            const SizedBox(height: 16),
            const Text(
              'Kamerazugriff nicht möglich',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
