import 'package:flutter/material.dart';
import 'package:manga/dto/manga_item_dto.dart';
import 'package:manga/pages/manga_detail_page.dart';
import 'package:manga/shared/utils.dart';
import 'package:breakpoints/breakpoints.dart';
import 'package:manga/shared/widgets/net_image.dart';

class MangaSearchPage extends SearchDelegate<String> {
  String oldQuery = '';

  Widget _listResults = const SizedBox();

  MangaSearchPage()
      : super(
          searchFieldLabel: '请输入关键字...',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, query),
    );
  }

  /// 提交时
  @override
  Widget buildResults(BuildContext context) {
    if (oldQuery.isNotEmpty && oldQuery == query) return _listResults;
    _listResults = ListResults(query: query);
    oldQuery = query;
    return _listResults;
  }

  /// 键入时
  @override
  Widget buildSuggestions(BuildContext context) {
    return _listResults;
  }
}

class ListResults extends StatefulWidget {
  final String query;

  const ListResults({Key key, this.query}) : super(key: key);

  @override
  _ListResultsState createState() => _ListResultsState();
}

class _ListResultsState extends State<ListResults> {
  List<MangaItemDto> _list = List<MangaItemDto>();
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

    var r = await $document('search/?keywords=${widget.query}&page=$page');
    var lis = $$(r, "#contList li");
    if (lis == null) {
      _list = List<MangaItemDto>();
    } else {
      _list = lis.map((it) {
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
    String query = widget.query;
    if (query.isEmpty) return SizedBox();
    if (loading) return Center(child: CircularProgressIndicator());
    if (_list.isEmpty) return Center(child: Text('关于 "$query"相关搜索，共找到"0"条结果'));
    return _displayResultList(_list);
  }

  /// 显示用户搜索结果列表
  Widget _displayResultList(List<MangaItemDto> list) {
    double width = MediaQuery.of(context).size.width;
    return ListView(
      key: PageStorageKey<String>('search_result'),
      children: <Widget>[
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
                  return MangaDetailPage(manga: it);
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
    );
  }
}
