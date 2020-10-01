class Chapter {
  final String name;
  final String href;

  Chapter({this.name, this.href});
}

class ComicChapters {
  final String title;
  final List<Chapter> chapterList;

  ComicChapters({this.title, this.chapterList});
}

class MangaDetailDto {
  final String detail;
  final List<ComicChapters> comicChapterss;

  MangaDetailDto({this.detail, this.comicChapterss});
}
