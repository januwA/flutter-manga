import 'package:dart_printf/dart_printf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga/dto/manga_item_dto.dart';
import 'package:manga/pages/manga_historys_page.dart';
import 'package:manga/pages/manga_search_page.dart';
import 'package:manga/shared/http.dart';
import 'package:manga/shared/utils.dart';
import 'package:manga/shared/widgets/manga_list_view.dart';
import 'package:html/dom.dart' as dom;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  List<MangaItemDto> _latestMangas = [];
  bool loading = true;

  dom.Document _doc;

  List<String> _dtabs = ['少女漫画', '少年漫画', '青年漫画'];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _doc = await $document(http.config.baseURL);

    //============================================================//
    //                   热门最新更新
    //============================================================//
    $$(_doc, "#updateWrap ul")?.map((ul) => $$(ul, 'li'))?.forEach((lis) {
      lis.forEach((li) => _latestMangas.add(getMangaItem(li)));
    });

    setState(() {
      loading = false;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manga'),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  showSearch<String>(
                    context: context,
                    delegate: MangaSearchPage(),
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(children: [
          ListTile(
            title: Text('历史记录'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return MangaHistorysPage();
                }),
              );
            },
          ),
        ]),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : CupertinoScrollbar(
              child: ListView(
                children: [
                  _buildLatestManga(),
                  MangaSection(
                    doc: _doc,
                    title: '热门漫画',
                    select: '#cmt-cont ul',
                    tabs: const ['热门连载', '经典完结', '最新上架', '热门古风'],
                  ),
                  MangaSection(
                    doc: _doc,
                    title: '热门连载',
                    select: '#serialCont ul',
                    tabs: _dtabs,
                  ),
                  MangaSection(
                    doc: _doc,
                    title: '经典完结',
                    select: '#finishCont ul',
                    tabs: _dtabs,
                  ),
                  MangaSection(
                    doc: _doc,
                    title: '最新上架',
                    select: '#latestCont ul',
                    tabs: _dtabs,
                  ),
                ],
              ),
            ),
    );
  }

  /// 热门漫画最近更新
  Widget _buildLatestManga() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            '热门漫画最新更新',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 10),
          MangaListView(mangas: _latestMangas),
        ],
      ),
    );
  }
}

class MangaSection extends StatefulWidget {
  final List<String> tabs;
  final String title;
  final dom.Document doc;
  final String select;

  const MangaSection({
    Key key,
    @required this.tabs,
    @required this.title,
    @required this.doc,
    @required this.select,
  }) : super(key: key);

  @override
  _MangaSectionState createState() => _MangaSectionState();
}

class _MangaSectionState extends State<MangaSection>
    with SingleTickerProviderStateMixin {
  List<List<MangaItemDto>> _list = [];
  TabController _tc;
  int index = 0;

  @override
  void initState() {
    super.initState();

    // init tab controller
    _tc = TabController(vsync: this, length: widget.tabs.length);
    _tc.addListener(() {
      if (!_tc.indexIsChanging) {
        printf('index change: %d', [_tc.index]);
        setState(() {
          index = _tc.index;
        });
      }
    });

    // init view data
    _list =
        $$(widget.doc, widget.select).map((ul) => getMangaItems(ul)).toList();
  }

  @override
  void dispose() {
    _tc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 10),
          TabBar(
            controller: _tc,
            tabs: widget.tabs.map((e) => Tab(text: e)).toList(),
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 10),
          MangaListView(mangas: _list[index]),
        ],
      ),
    );
  }
}
