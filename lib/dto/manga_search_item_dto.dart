import 'package:manga/dto/latest_manga_dto.dart';

class MangaSearchItemDto extends LatestMangaDto {
  MangaSearchItemDto({String name, String href, String img})
      : super(
          href: href,
          name: name,
          img: img,
        );
}
