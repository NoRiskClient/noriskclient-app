import 'package:flutter/material.dart';

import '../../config/Colors.dart';
import '../../widgets/NoRiskBackButton.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({super.key, required this.image});

  Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: NoRiskClientColors.darkerBackground,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: InteractiveViewer(
                child: Image(image: image.image, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 10,
            child: NoRiskBackButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
