import 'dart:io';

import 'package:dart_printf/dart_printf.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class MangaDB {
  static MangaDB _o;

  /// 浏览manga的历史记录表
  static final String historyTable = 'historys';

  Future<Database> database;

  MangaDB._() {
    _openDB();
  }

  factory MangaDB() {
    if (_o == null) {
      _o = MangaDB._();
    }
    return _o;
  }

  _openDB() async {
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfi;
    }
    var dbPath = p.join(await getDatabasesPath(), 'flutter_manga.db');
    printf(dbPath);
    database = openDatabase(
      dbPath,
      onCreate: (db, version) async {
        try {
          await db.execute(
            '''
          CREATE TABLE $historyTable (
              id                INTEGER PRIMARY KEY AUTOINCREMENT,
              mangaName         TEXT UNIQUE  
                                     NOT NULL
          );
         ''',
          );
        } catch (e) {
          print('建表失败.');
        }
      },
      version: 1,
    );
  }
}
