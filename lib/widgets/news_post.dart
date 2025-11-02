import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/widgets/no_risk_container.dart';
import 'package:noriskclient/widgets/no_risk_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NewsPost extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String link;
  final String postedAt;
  final bool isNewest;

  const NewsPost({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.link,
    required this.postedAt,
    this.isNewest = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrlString(link, mode: LaunchMode.externalApplication),
      child: NoRiskContainer(
        color: isNewest ? NoRiskClientColors.blue : Colors.white,
        padding: const EdgeInsets.only(
          top: 2.5,
          bottom: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            Row(
              children: [
                NoRiskText(
                  title.toLowerCase(),
                  maxLength:
                      MediaQuery.of(context).size.width - 2 * 15 - 2 * 10 - 115,
                  spaceTop: false,
                  spaceBottom: false,
                  style: TextStyle(
                    fontSize: 25,
                    color: NoRiskClientColors.text,
                  ),
                ),
                const Spacer(),
                NoRiskText(
                  postedAt,
                  spaceTop: false,
                  spaceBottom: false,
                  style: TextStyle(
                    fontSize: 25,
                    color: NoRiskClientColors.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: MediaQuery.of(context).size.width - 2 * 15 - 2 * 10,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
