import 'package:flutter/material.dart';
import 'package:manga/shared/url_path.dart';
import 'package:manga/shared/utils.dart';
import 'package:manga/shared/widgets/net_image.dart';

class ReadMangaPage extends StatefulWidget {
  static const routeName = '/ReadMangaPage';
  final String href;

  const ReadMangaPage({Key key, this.href}) : super(key: key);
  @override
  RreaMmangPpageState createState() => RreaMmangPpageState();
}

class RreaMmangPpageState extends State<ReadMangaPage> {
  bool laoding = true;
  List<String> images = [];
  String title = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    var r = await $document(widget.href);
    title = $(r, '.title h1 a').text.trim();
    title += ' / ';
    title += $(r, '.title h2').text.trim();

    var script1 = $(r, 'body script').text.trim();

    var chapterPathIndex = script1.indexOf('chapterPath');
    var chapterPath = script1.substring(chapterPathIndex, script1.length);
    chapterPath = chapterPath.substring(0, chapterPath.indexOf(';'));
    var exp1 = RegExp(r'"([^"]+)"');
    chapterPath = exp1.firstMatch(chapterPath)[1];

    // 获取images数组
    var chapterImagesIndex = script1.indexOf('chapterImages');
    var chapterImages = script1.substring(chapterImagesIndex, chapterPathIndex);
    var exp2 = RegExp(r'([\da-zA-Z_-]+\.[a-zA-Z]+)');
    var matches = exp2.allMatches(chapterImages);
    matches.forEach((it) {
      images.add(urlPath.normalize(
          urlPath.joinAll(['https://res.xiaoqinre.com', chapterPath, it[1]])));
    });

    setState(() {
      laoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: laoding
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return netImage(images[index]);
              },
            ),
    );
  }
}
