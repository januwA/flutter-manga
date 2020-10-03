import 'package:manga/dto/latest_manga_dto.dart';

class MangaItemDto extends LatestMangaDto {
  MangaItemDto({String name, String href, String img})
      : super(
          href: href,
          name: name,
          img: img,
        );
}
