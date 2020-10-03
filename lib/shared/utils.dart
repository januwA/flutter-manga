import 'package:html/parser.dart' as html;
import 'package:html/dom.dart' as dom;
import 'package:manga/shared/http.dart';

dom.Element $(parent, String select) => parent.querySelector(select);

List<dom.Element> $$(parent /*Element|Document*/, String select) =>
    parent.querySelectorAll(select);

Future<dom.Document> $document(String url) =>
    http.get(url).then((r) => html.parse(r.body));