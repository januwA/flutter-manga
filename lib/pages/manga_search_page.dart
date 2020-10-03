import 'package:flutter/material.dart';
import 'package:manga/dto/manga_item_dto.dart';
import 'package:manga/shared/utils.dart';
import 'package:manga/shared/widgets/manga_grid_view.dart';

class MangaSearchPage extends SearchDelegate<String> {
  String oldQuery = '';

  Widget _listResults = const SizedBox();

  @override
  appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  TextInputType get keyboardType => TextInputType.text;

  @override
  TextInputAction get textInputAction => TextInputAction.search;

  @override
  TextStyle get searchFieldStyle => TextStyle(
        color: Colors.grey[800],
      );

  @override
  String get searchFieldLabel => '请输入关键字...';

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
  List<MangaItemDto> mangas;
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
    String query = widget.query;
    if (query.isEmpty) return SizedBox();
    if (loading) return Center(child: CircularProgressIndicator());
    if (mangas.isEmpty) return Center(child: Text('关于 "$query"相关搜索，共找到"0"条结果'));
    return ListView(
      key: PageStorageKey<String>('search_result'),
      children: <Widget>[
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
    );
  }
}
