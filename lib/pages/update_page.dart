import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga/dto/manga_search_item_dto.dart';
import 'package:breakpoints/breakpoints.dart';
import 'package:manga/pages/manga_detail_page.dart';
import 'package:manga/shared/utils.dart';
import 'package:manga/shared/widgets/net_image.dart';

class UpdatePage extends StatefulWidget {
  static const routeName = '/UpdatePage';
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage>
    with AutomaticKeepAliveClientMixin {
  List<MangaItemDto> list = [];
  bool loading = true;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
      loading = true;
    });

    var r = await $document('update/$page/');
    var lis = $$(r, "#contList li");
    if (lis == null) {
      list = List<MangaItemDto>();
    } else {
      list = lis.map((it) {
        var cover = $(it, '.cover');
        return MangaItemDto(
          name: cover.attributes['title'].trim(),
          href: cover.attributes['href'].trim(),
          img: $(cover, 'img').attributes['src'],
        );
      }).toList();
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) return Center(child: CircularProgressIndicator());
    if (list.isEmpty) return Center(child: Text('没有数据'));

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('最新更新'),
      ),
      body: CupertinoScrollbar(
        child: ListView(
          children: [
            GridView.count(
              primary: false,
              shrinkWrap: true,
              crossAxisCount: width.isXs
                  ? 2
                  : width.isSm
                      ? 3
                      : width.isMd
                          ? 4
                          : width.isLg
                              ? 5
                              : width.isXl
                                  ? 6
                                  : 10,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 0.8,
              children: list.map((it) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return MangaDetailPage(latestMangaDto: it);
                    }));
                  },
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: netImage(it.img)),
                        ListTile(
                          title: Text(it.name),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    if (page <= 1) return;
                    page--;
                    _init();
                  },
                  child: Text('上一页'),
                ),
                SizedBox(width: 8.0),
                RaisedButton(
                  onPressed: () {
                    page++;
                    _init();
                  },
                  child: Text('下一页'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
