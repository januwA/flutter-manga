import 'package:flutter/material.dart';
import 'package:manga/pages/dash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashPage(),
    );
  }
}
