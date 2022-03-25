import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'pages/config_page.dart';
import 'pages/home_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  var _currentIndex = 0;
  List<Widget> pages = <Widget>[];
   static Color appBarColor = Colors.black;
   List<Color> appBarBgColors = <Color>[Color.fromRGBO(47, 185, 202, 0.3), Color.fromRGBO(255,255,255,0.1)];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages
      ..add(HomePage())
      ..add(ConfigPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarBgColors[_currentIndex],
        elevation: 0,
        title: Text("欢迎回来, ofg",
          style: TextStyle(
            color: Color(0xFF303E57),
          ),
        ),
        actions: [IconButton(onPressed: () =>{}, icon: Icon(CupertinoIcons.add_circled_solid ,size: 30,color: Color(0xFF303E57)))],
      ),
      bottomNavigationBar: SalomonBottomBar(
        margin: const EdgeInsets.all(12),
        // itemPadding: EdgeInsets.fromLTRB(8,5,8,5),
        curve: Curves.ease,
        decoration: new BoxDecoration(
          // boxShadow: [BoxShadow(color: Color.fromRGBO(240,240,240,1), blurRadius: 8.0)],
          color: Color(0xFFF8F9FC)
        ),
        duration: const Duration(milliseconds: 250),
        currentIndex: _currentIndex,
        // itemPadding: EdgeInsets.only(left: ),
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.house_alt_fill),
            title: const Text("主页"),
            selectedColor: Colors.teal,
          ),
          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(CupertinoIcons.person_fill),
            title: const Text("我的"),
            selectedColor: Colors.purple,
          ),
        ],
      ),
      body: pages[_currentIndex],
    );
  }


}
