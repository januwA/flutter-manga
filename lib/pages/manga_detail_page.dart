import 'package:flutter/material.dart';
import 'package:manga/dto/manga_item_dto.dart';
import 'package:manga/dto/manga_detail_dto.dart';
import 'package:manga/pages/read_manga_page.dart';
import 'package:manga/shared/utils.dart';
import 'package:manga/shared/widgets/net_image.dart';

class MangaDetailPage extends StatefulWidget {
  static const routeName = '/MangaDetailPage';
  final MangaItemDto manga;

  const MangaDetailPage({Key key, this.manga}) : super(key: key);

  @override
  _MangaDetailPageState createState() => _MangaDetailPageState();
}

class _MangaDetailPageState extends State<MangaDetailPage> {
  MangaDetailDto mangaDetailDto;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    var r = await $document(widget.manga.href);
    var detail = $(r, '#intro-cut p').text.trim();
    var divs = $$(r, ".comic-chapters");

    var comicChapterss = divs.map((it) {
      return ComicChapters(
        title: $(it, '.caption span').text.trim(),
        chapterList: $$(it, 'ul li').map((e) {
          return Chapter(
            name: $(e, 'a').text.trim(),
            href: $(e, 'a').attributes['href'],
          );
        }).toList(),
      );
    }).toList();
    mangaDetailDto = MangaDetailDto(
      detail: detail,
      comicChapterss: comicChapterss,
    );
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.manga.name),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                netImage(widget.manga.img),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(mangaDetailDto.detail),
                ),
                for (var it in mangaDetailDto.comicChapterss)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          it.title,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Wrap(
                          spacing: 8.0,
                          children: it.chapterList.map((e) {
                            return RaisedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ReadMangaPage(href: e.href);
                                }));
                              },
                              child: Text(e.name),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
