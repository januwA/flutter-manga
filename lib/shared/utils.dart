import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;
import 'package:manga/dto/manga_item_dto.dart';
import 'package:manga/shared/http.dart';

dom.Element $(parent, String select) => parent.querySelector(select);

List<dom.Element> $$(parent /*Element|Document*/, String select) =>
    parent.querySelectorAll(select);

Future<dom.Document> $document(String url) =>
    http.get(url).then((r) => html.parse(r.body));

MangaItemDto getMangaItem(dom.Element li) {
  var cover = $(li, '.cover');
  assert(cover != null);
  return MangaItemDto(
    name: cover.attributes['title'].trim(),
    href: cover.attributes['href'].trim(),
    img: $(cover, 'img').attributes['src'],
  );
}

List<MangaItemDto> getMangaItems(dom.Element ul) {
  return $$(ul, "li")?.map((li) => getMangaItem(li))?.toList() ?? [];
}
