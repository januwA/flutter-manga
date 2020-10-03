import 'package:flutter/material.dart';
import 'package:manga/dto/manga_item_dto.dart';
import 'package:breakpoints/breakpoints.dart';
import 'package:manga/shared/widgets/manga_grid.dart';

class MangaGridView extends StatelessWidget {
  final List<MangaItemDto> mangas;

  const MangaGridView({Key key, this.mangas}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GridView.count(
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
      children: mangas.map((it) => MangaGrid(manga: it)).toList(),
    );
  }
}
