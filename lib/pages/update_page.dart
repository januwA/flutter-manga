import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga/dto/manga_item_dto.dart';
import 'package:manga/shared/utils.dart';
import 'package:manga/shared/widgets/manga_grid_view.dart';

class UpdatePage extends StatefulWidget {
  static const routeName = '/UpdatePage';
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage>
    with AutomaticKeepAliveClientMixin {
  List<MangaItemDto> mangas = [];
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
      mangas = List<MangaItemDto>();
    } else {
      mangas = lis.map((li) => getMangaItem(li)).toList();
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) return Center(child: CircularProgressIndicator());
    if (mangas.isEmpty) return Center(child: Text('没有数据'));
    return Scaffold(
      appBar: AppBar(
        title: Text('最新更新'),
      ),
      body: CupertinoScrollbar(
        child: ListView(
          children: [
            MangaGridView(mangas: mangas),
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
