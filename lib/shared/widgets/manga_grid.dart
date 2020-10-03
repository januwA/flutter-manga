import 'package:flutter/material.dart';
import 'package:manga/dto/manga_item_dto.dart';
import 'package:manga/pages/manga_detail_page.dart';
import 'package:manga/shared/widgets/net_image.dart';

class MangaGrid extends StatelessWidget {
  final MangaItemDto manga;

  const MangaGrid({Key key, this.manga}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return MangaDetailPage(manga: manga);
          }));
        },
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: netImage(manga.img)),
              ListTile(
                title: Text(manga.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
