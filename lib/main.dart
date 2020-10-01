import 'package:flutter/material.dart';
import 'package:manga/pages/manga_detail_page.dart';
import 'package:manga/shared/http.dart';
import 'package:manga/shared/utils.dart';
import 'package:manga/shared/widgets/net_image.dart';

import 'dto/latest_manga_dto.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LatestMangaDto> latestMangas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    var r = await $document(http.config.baseURL);
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
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manga')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildLatestManga(),
              ],
            ),
    );
  }

  _buildLatestManga() {
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
}
