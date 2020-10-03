import 'package:flutter/material.dart';
import 'package:manga/pages/update_page.dart';

import 'home_page.dart';

class DashPage extends StatefulWidget {
  static const routeName = '/DashPage';
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  int _currentIndex = 0;
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        fixedColor: Colors.purple,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _controller.jumpToPage(index);
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.update),
            label: "最新",
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          HomePage(),
          UpdatePage(),
        ],
      ),
    );
  }
}
