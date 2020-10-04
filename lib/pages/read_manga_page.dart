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

// 缩放
  double _scale = 1.0;
  double _baseScale = 0;
  double get scale {
    if (_scale < 1.0) _scale = 1.0;
    return _scale;
  }

// 平移
  Offset _pos = Offset(0, 0);
  Offset _basePos = Offset(0, 0);

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

  void _onScaleStart(ScaleStartDetails d) {
    _baseScale = _scale;
    _basePos = d.localFocalPoint - _pos;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    setState(() {
      // 再放大时，避免平移
      if (_baseScale * d.scale == _scale) {
        _pos = d.localFocalPoint - _basePos;
      }
      _scale = _baseScale * d.scale;
    });
  }

  /// 双击还原
  void _onDoubleTap() {
    setState(() {
      _scale = 1.0;
      _pos = Offset(0, 0);
      _basePos = Offset(0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: laoding
            ? Center(child: CircularProgressIndicator())
            : GestureDetector(
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                child: Transform(
                  transform: Matrix4.identity()
                    ..scale(scale, scale)
                    ..translate(_pos.dx, _pos.dy),
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) => netImage(images[index]),
                  ),
                ),
              ),
      ),
    );
  }
}
