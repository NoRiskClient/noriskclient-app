import 'package:flutter/material.dart';
import 'package:noriskclient/config/colors.dart';
import 'package:noriskclient/utils/nr_icons.dart';
import 'package:noriskclient/widgets/common/nr_container.dart';
import 'package:noriskclient/widgets/common/nr_text.dart';
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
    final textColor = isNewest ? Colors.white : NoRiskClientColors.text;

    return GestureDetector(
      onTap: () => launchUrlString(link, mode: LaunchMode.externalApplication),
      child: NoRiskContainer(
        color: isNewest ? NoRiskClientColors.blue : NoRiskClientColors.surface,
        backgroundOpacity: 255,
        padding: const EdgeInsets.only(top: 6, bottom: 10, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'SmallCapsMC',
                      fontSize: 10,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    NRIcons.svg('calendar', color: textColor, size: 13),
                    const SizedBox(width: 4),
                    NoRiskText(
                      postedAt,
                      spaceTop: false,
                      spaceBottom: false,
                      style: TextStyle(fontSize: 10, color: textColor),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
