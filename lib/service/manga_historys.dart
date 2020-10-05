import 'package:manga/db/manga_db.dart';
import 'package:sqflite/sqflite.dart';

class MangaHistorysService {
  MangaDB _db = MangaDB();

  /// 添加一条历史记录
  Future<int> insert(String mangaName) async {
    return (await _db.database).insert(
      MangaDB.historyTable,
      {
        'mangaName': mangaName,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 删除历史记录
  Future<int> delete(int id) async {
    return (await _db.database).delete(
      MangaDB.historyTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  /// 返回所有历史记录
  Future<List<Map<String, dynamic>>> getAll() async {
    return (await _db.database).query(MangaDB.historyTable);
  }
}
