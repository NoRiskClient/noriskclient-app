import 'package:flutter/material.dart';

import '../config/colors.dart';
import '../utils/no_risk_api.dart';
import '../widgets/news_post.dart';
import '../widgets/no_risk_text.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Widget> news = [];

  @override
  void initState() {
    loadNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: NoRiskClientColors.background,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: 55,
        ),
        child: RefreshIndicator(
          onRefresh: loadNews,
          child: ListView(children: news),
        ),
      ),
    );
  }

  Future<void> loadNews() async {
    List<dynamic> posts = await NoRiskApi().getBlogPostsAndChangeLogs();
    List<Widget> newsPosts = [];

    for (var post in posts) {
      bool isNewest = posts.indexOf(post) == 0;
      if (isNewest) {
        newsPosts.add(
          NoRiskText(
            'Newest'.toLowerCase(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: NoRiskClientColors.text,
            ),
          ),
        );
      }
      newsPosts.add(
        NewsPost(
          title: post['title']['rendered'],
          imageUrl: post['yoast_head_json']?['og_image']?[0]?['url'] ?? '',
          link: post['link'],
          postedAt: post['date'].split('T')[0].split('-').reversed.join('.'),
          isNewest: isNewest,
        ),
      );
      newsPosts.add(const SizedBox(height: 10));
      if (isNewest) {
        newsPosts.add(
          NoRiskText(
            'Older Posts'.toLowerCase(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: NoRiskClientColors.text,
            ),
          ),
        );
      }
    }

    news = newsPosts;
    if (mounted) setState(() {});
  }
}
