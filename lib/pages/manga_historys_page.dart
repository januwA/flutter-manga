import 'package:dart_printf/dart_printf.dart';
import 'package:flutter/material.dart';
import 'package:manga/dto/manga_item_dto.dart';
import 'package:manga/main.dart';
import 'package:manga/service/manga_historys.dart';
import 'package:manga/shared/utils.dart';
import 'package:manga/shared/widgets/manga_grid_view.dart';

class MangaHistorysPage extends StatefulWidget {
  static const routeName = '/MangaHistorysPage';
  @override
  _MangaHistorysPageState createState() => _MangaHistorysPageState();
}

class _MangaHistorysPageState extends State<MangaHistorysPage> {
  final hsService = getIt<MangaHistorysService>();
  List<MangaItemDto> mangas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    var map = await hsService.getAll();
    printf('datas: %o', [map]);

    for (var it in map) {
      var mangaName = it['mangaName'];
      var r = await $document('/manhua/$mangaName/');
      mangas.add(MangaItemDto(
        name: $(r, '.book-title h1 span').text.trim(),
        href: 'https://www.gufengmh8.com/manhua/$mangaName/',
        img: $(r, '.pic').attributes['src'],
      ));
    }

    printf('[mangas length]: %d', [mangas.length]);

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('历史记录'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : mangas.isEmpty
              ? Center(child: Text('没有数据.'))
              : MangaGridView(mangas: mangas),
    );
  }
}
