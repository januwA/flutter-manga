import 'package:flutter/material.dart';
import 'package:manga/dto/manga_item_dto.dart';
import 'package:manga/shared/widgets/manga_grid.dart';

class MangaListView extends StatelessWidget {
  final List<MangaItemDto> mangas;

  const MangaListView({Key key, this.mangas}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        itemCount: mangas.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => MangaGrid(manga: mangas[index]),
      ),
    );
  }
}
