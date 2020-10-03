import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga/dto/latest_manga_dto.dart';
import 'package:manga/dto/manga_search_item_dto.dart';
import 'package:manga/pages/manga_detail_page.dart';
import 'package:manga/pages/manga_search_page.dart';
import 'package:manga/shared/http.dart';
import 'package:manga/shared/utils.dart';
import 'package:manga/shared/widgets/net_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  List<LatestMangaDto> latestMangas = [];
  bool loading = true;

  /// ================================================= 热门漫画
  final List<Tab> _hotTabs = <Tab>[
    Tab(text: '热门连载'),
    Tab(text: '经典完结'),
    Tab(text: '最新上架'),
    Tab(text: '热门古风'),
  ];
  List<List<MangaItemDto>> _hotMangaList = [];
  TabController _tabController;
  int _hotIndex = 0;
  /// =================================================

  @override
  void initState() {
    super.initState();
    init();
    _tabController = TabController(vsync: this, length: _hotTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void init() async {
    var r = await $document(http.config.baseURL);

    // ============================================================ 热门最新更新
    var updateWrap = $(r, "#updateWrap");
    var uls = $$(updateWrap, "ul");
    uls.map((ul) => $$(ul, 'li')).forEach((lis) {
      lis.forEach((li) {
        var href = $(li, 'p a').attributes['href'];
        var mangaName = $(li, 'p a').text.trim();
        var img = $(li, 'img').attributes['src'];
        // printf("%s\n%s\n%s", [href, mangaName, img]);
        latestMangas.add(LatestMangaDto(href: href, name: mangaName, img: img));
      });
    });
    // ============================================================

    // ============================================================ 热门漫画
    uls = $$(r, '#cmt-cont ul');
    _hotMangaList = uls.map((ul) {
      return $$(ul, "li").map((li) {
        var cover = $(li, '.cover');
        return MangaItemDto(
          name: cover.attributes['title'].trim(),
          href: cover.attributes['href'].trim(),
          img: $(cover, 'img').attributes['src'],
        );
      }).toList();
    }).toList();
    // ============================================================
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
      body: loading
          ? Center(child: CircularProgressIndicator())
          : CupertinoScrollbar(
              child: ListView(
                children: [
                  _buildLatestManga(),
                  SizedBox(height: 10),
                  _buildHotManga(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '热门漫画最新更新',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: latestMangas.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var it = latestMangas[index];
                return SizedBox(
                  width: 200,
                  child: InkWell(
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 热门漫画
  Widget _buildHotManga() {
    return DefaultTabController(
      length: _hotTabs.length,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              setState(() {
                _hotIndex = tabController.index;
              });
              // 您的代码在这里。
              // 要获取当前标签的索引，请使用tabController.index
            }
          });
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '热门漫画',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
              TabBar(
                tabs: _hotTabs,
                isScrollable: true,
                labelColor: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _hotMangaList[_hotIndex].length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var it = _hotMangaList[_hotIndex][index];
                    return SizedBox(
                      width: 200,
                      child: InkWell(
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
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
