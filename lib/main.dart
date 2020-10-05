import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:manga/pages/dash_page.dart';
import 'package:manga/service/manga_historys.dart';

GetIt getIt = GetIt.instance;
void main() {
  getIt..registerSingleton<MangaHistorysService>(MangaHistorysService());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: DashPage(),
    );
  }
}
